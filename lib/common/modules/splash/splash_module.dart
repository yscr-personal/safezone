import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/modules/splash/splash_screen.dart';

class SplashModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const SplashScreen()),
      ];
}
