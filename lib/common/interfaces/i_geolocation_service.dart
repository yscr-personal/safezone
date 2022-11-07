abstract class IGeolocationService {
  Future getCurrentLocation();

  void startLocationTracking({
    void Function(dynamic position)? onLocationUpdate,
  });

  void stopLocationTracking();
}
