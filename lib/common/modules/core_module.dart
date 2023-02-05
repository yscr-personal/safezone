import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/cubits/websocket/websocket_cubit.dart';
import 'package:unb/common/services/protocols/i_auth_service.dart';
import 'package:unb/common/services/protocols/i_geolocation_service.dart';
import 'package:unb/common/services/protocols/i_http_service.dart';
import 'package:unb/common/services/dio_http_service.dart';
import 'package:unb/common/services/geolocator_geo_service.dart';
import 'package:unb/common/clients/safezone_api/auth_service.dart';
import 'package:unb/common/storage/user_preferences.dart';

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => UserPreferences(),
          export: true,
        ),
        Bind<IHttpService>(
          (i) => DioHttpService(),
          export: true,
        ),
        Bind(
          (i) => Logger(),
          export: true,
        ),
        Bind<IGeolocationService>(
          (i) => GeolocationService(),
          export: true,
        ),
        Bind<IAuthService>(
          (i) => AuthService(i(), i()),
          export: true,
        ),
        Bind(
          (i) => AuthCubit(i()),
          export: true,
        ),
        Bind(
          (i) => WebsocketCubit(),
          export: true,
        ),
      ];
}
