import 'package:geolocator/geolocator.dart';

abstract class IGeolocationService {
  Future getCurrentLocation();

  void startLocationTracking({
    void Function(Position position)? onLocationUpdate,
  });

  void stopLocationTracking();
}
