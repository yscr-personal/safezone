import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/modules/auth/login/login_controller.dart';
import 'package:unb/modules/auth/login/login_screen.dart';

class LoginModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => LoginController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => const LoginScreen()),
      ];
}
