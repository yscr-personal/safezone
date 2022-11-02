import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class GeolocationService {
  StreamSubscription<Position>? _positionStream;
  final _logger = Modular.get<Logger>();

  Future<Position> determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  void init({
    void Function(Position position)? onLocationUpdate,
  }) {
    _logger.i('[GeolocationService] - init');
    _watchPosition(onLocationUpdate);
  }

  void dispose() {
    _logger.i('[GeolocationService] - disposed');
    _positionStream?.cancel();
    _positionStream = null;
  }

  void _watchPosition(void Function(Position position)? onLocationUpdate) {
    if (_positionStream != null) {
      return;
    }

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
