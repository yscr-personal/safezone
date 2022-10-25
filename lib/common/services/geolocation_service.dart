import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class GeolocationService {
  late Stream<Position> positionStream;
  final logger = Modular.get<Logger>();

  Future<Position> determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  void init() async {
    watchPosition();
    watchLocationStatus();
  }

  void watchPosition() async {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    );

    positionStream.listen((Position position) {
      logger.d('${position.latitude}, ${position.longitude}');
    });
  }

  void watchLocationStatus() {
    Geolocator.getServiceStatusStream().listen((final status) {
      logger.d(status);
    });
  }
}
