import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/modules/auth/signup/confirmation_code_screen.dart';
import 'package:unb/modules/auth/signup/signup_controller.dart';
import 'package:unb/modules/auth/signup/signup_screen.dart';

class SignUpModule extends Module {
  @override
  List<Bind> get binds => [Bind((i) => SignupController())];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => const SignUpScreen()),
        ChildRoute(
          '/confirm-code',
          child: (_, args) => ConfirmationCodeScreen(
            username: args.queryParams['username'],
          ),
        ),
      ];
}
