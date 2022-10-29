import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/modules/auth/signup/signup_screen.dart';

class SignUpModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => const SignUpScreen()),
      ];
}
