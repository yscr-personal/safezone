import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/interfaces/i_auth_service.dart';
import 'package:unb/common/interfaces/i_geolocation_service.dart';
import 'package:unb/common/interfaces/i_http_service.dart';
import 'package:unb/common/services/aws_auth_service.dart';
import 'package:unb/common/services/dio_http_service.dart';
import 'package:unb/common/services/geolocator_geo_service.dart';
import 'package:unb/common/storage/user_preferences.dart';

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<IAuthService>(
          (i) => AwsAuthService(),
          export: true,
        ),
        Bind.singleton<IHttpService>(
          (i) => DioHttpService(),
          export: true,
        ),
        Bind.singleton(
          (i) => UserPreferences(),
          export: true,
        ),
        Bind.singleton(
          (i) => Logger(),
          export: true,
        ),
        Bind.singleton<IGeolocationService>(
          (i) => GeolocationService(),
          export: true,
        ),
        Bind.singleton(
          (i) => AuthCubit(authService: i()),
          export: true,
        ),
      ];
}
