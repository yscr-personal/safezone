import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/services/aws_auth_service.dart';
import 'package:unb/common/services/dio_http_service.dart';
import 'package:unb/common/services/geolocation_service.dart';
import 'package:unb/common/storage/user_preferences.dart';

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => AwsAuthService(), export: true),
        Bind.singleton((i) => DioHttpService(), export: true),
        Bind.singleton((i) => UserPreferences(), export: true),
        Bind.singleton((i) => Logger(), export: true),
        Bind.singleton((i) => GeolocationService(), export: true),
        Bind.singleton((i) => AuthCubit(authService: i()), export: true),
      ];
}
