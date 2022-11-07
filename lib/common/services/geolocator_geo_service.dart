import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/interfaces/i_geolocation_service.dart';

class GeolocationService implements IGeolocationService {
  late StreamSubscription<Position>? _positionStream;
  final _logger = Modular.get<Logger>();

  @override
  Future getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  @override
  void startLocationTracking(
      {void Function(dynamic position)? onLocationUpdate}) {
    _logger.i('[GeolocationService] - init');
    _watchPosition(onLocationUpdate);
  }

  @override
  void stopLocationTracking() {
    _logger.i('[GeolocationService] - dispose');
    _positionStream?.cancel();
    _positionStream = null;
  }

  void _watchPosition(void Function(Position position)? onLocationUpdate) {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    ).listen((final Position position) {
      _logger.d(
          '[${DateTime.now().toString()}] lat=${position.latitude}, lng=${position.longitude}');
      if (onLocationUpdate != null) {
        onLocationUpdate(position);
      }
    });
  }
}
