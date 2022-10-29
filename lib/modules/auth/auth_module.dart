import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/modules/auth/login/login_module.dart';
import 'package:unb/modules/auth/signup/signup_module.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: LoginModule()),
        ModuleRoute('/signup', module: SignUpModule()),
      ];
}
