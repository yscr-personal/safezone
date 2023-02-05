import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:unb/common/environment_config.dart';
import 'package:unb/modules/home/models/location_received_payload.dart';

part 'websocket_state.dart';

class WebsocketCubit extends Cubit<WebsocketState> {
  final _logger = Modular.get<Logger>();

  WebsocketCubit() : super(WebsocketInitial());

  void connect() {
    emit(WebsocketLoading());
    try {
      _logger.i(
          '[Websocket] - connecting to ${EnvironmentConfig.SAFEZONE_WEBSOCKET_URL}');
      final socket = io(
        EnvironmentConfig.SAFEZONE_WEBSOCKET_URL,
        OptionBuilder().setTransports(['websocket']).build(),
      );
      socket.connect();
      emit(WebsocketLoaded(socket: socket));
    } catch (exception, stackTrace) {
      _captureException(exception, stackTrace);
    }
  }

  void disconnect() async {
    if (state is! WebsocketLoaded) return;

    try {
      final socket = (state as WebsocketLoaded).socket;
      socket.dispose();
      emit(WebsocketInitial());
    } catch (exception, stackTrace) {
      _captureException(exception, stackTrace);
    }
  }

  void sendLocationUpdate(final String userId, final LatLng pos) async {
    if (state is! WebsocketLoaded) return;

    try {
      final socket = (state as WebsocketLoaded).socket;
      socket.emit('send_location', {
        'userId': userId,
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      });
      emit(WebsocketLoaded(socket: socket));
    } catch (exception, stackTrace) {
      _captureException(exception, stackTrace);
    }
  }

  void listenToReceiveLocationUpdate(
    final Function(LocationReceivedPayload data) onLocationUpdate,
  ) async {
    if (state is! WebsocketLoaded) return;

    _logger.i('[ListenToReceiveLocationUpdate] - init');

    try {
      final socket = (state as WebsocketLoaded).socket;
      socket.on(
        'receive_location_update',
        (final payload) => onLocationUpdate(
          LocationReceivedPayload.fromJson(payload),
        ),
      );
    } catch (exception, stackTrace) {
      _captureException(exception, stackTrace);
    }
  }

  _captureException(exception, stackTrace) async {
    _logger.e(exception.toString());
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
    emit(WebsocketError(message: exception.toString()));
  }
}
