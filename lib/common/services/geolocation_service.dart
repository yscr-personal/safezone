import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class GeolocationService {
  Stream<Position>? _positionStream;
  final _logger = Modular.get<Logger>();

  Future<Position> determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  void init({
    void Function(Position position)? onLocationUpdate,
  }) {
    _watchPosition(onLocationUpdate);
  }

  void _watchPosition(void Function(Position position)? onLocationUpdate) {
    if (_positionStream != null) {
      return;
    }

    _logger.i('initializing geolocation service');
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    );

    _positionStream!.listen((final Position position) {
      _logger.d(
          '[${DateTime.now().toString()}] lat=${position.latitude}, lng=${position.longitude}');
      if (onLocationUpdate != null) {
        onLocationUpdate(position);
      }
    });
  }
}
