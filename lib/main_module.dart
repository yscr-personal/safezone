import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';
import 'package:unb/common/environment_config.dart';
import 'package:unb/common/guards/auth_guard.dart';
import 'package:unb/common/interfaces/i_http_service.dart';
import 'package:unb/common/services/dio_http_service.dart';
import 'package:unb/common/storage/user_preferences.dart';
import 'package:unb/modules/auth/auth_module.dart';
import 'package:unb/modules/home/home_module.dart';
import 'package:unb/modules/loading/loading_screen.dart';

class AppModule extends Module {
  final UserPreferences userPreferences;
  final SharedPreferences sharedPreferences;
  final AuthBloc authBloc;

  AppModule({
    required this.userPreferences,
    required this.sharedPreferences,
    required this.authBloc,
  });

  @override
  List<Bind> get binds => [
        Bind(
          (i) => Dio(
            BaseOptions(
              baseUrl: EnvironmentConfig.BACKEND_URL,
              connectTimeout: 5000,
              receiveTimeout: 3000,
              contentType: 'application/json',
              validateStatus: (status) => status! < 500,
            ),
          ),
        ),
        Bind<IHttpService>((i) => DioHttpService(i())),
        Bind((i) => sharedPreferences),
        Bind((i) => userPreferences),
        Bind((i) => authBloc),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => const LoadingScreen()),
        ModuleRoute('/home', module: HomeModule(), guards: [AuthGuard()]),
        ModuleRoute('/auth', module: AuthModule()),
      ];
}
