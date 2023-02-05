import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/websocket/websocket_cubit.dart';

class WebsocketGuard extends RouteGuard {
  final _logger = Modular.get<Logger>();
  final _websocketCubit = Modular.get<WebsocketCubit>();

  WebsocketGuard() : super(redirectTo: '/Websocket/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final ok = await _hasActiveSocket();
    _logger.i('[WebsocketGuard] - Allow access to $path: $ok');
    return Future.value(ok);
  }

  Future<bool> _hasActiveSocket() async {
    return _websocketCubit.state is WebsocketLoaded;
  }
}
