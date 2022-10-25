import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';
import 'package:unb/common/guards/auth_guard.dart';
import 'package:unb/common/guards/geo_guard.dart';
import 'package:unb/common/modules/core_module.dart';
import 'package:unb/common/modules/no_location_enabled/no_location_module.dart';
import 'package:unb/common/modules/splash/splash_module.dart';
import 'package:unb/modules/auth/auth_module.dart';
import 'package:unb/modules/home/home_module.dart';

class AppModule extends Module {
  final AuthBloc authBloc;

  AppModule({
    required this.authBloc,
  });

  @override
  List<Module> get imports => [
        CoreModule(authBloc),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: SplashModule()),
        ModuleRoute(
          '/no_location',
          module: NoLocationServiceModule(),
        ),
        ModuleRoute(
          '/home',
          module: HomeModule(),
          guards: [
            AuthGuard(),
            GeoGuard(),
          ],
        ),
        ModuleRoute('/auth', module: AuthModule()),
      ];
}
