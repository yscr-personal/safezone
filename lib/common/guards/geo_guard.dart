import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class GeoGuard extends RouteGuard {
  final Logger logger = Modular.get();

  GeoGuard() : super(redirectTo: '/no_location/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final ok = await _isLocationAvailable();
    logger.i('[GeoGuard] - Allow access to $path: $ok');
    return Future.value(ok);
  }

  Future<bool> _isLocationAvailable() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}
