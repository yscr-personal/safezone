import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';

class LoginController {
  final AuthCubit _authCubit = Modular.get();

  void authenticateUser(
    final String email,
    final String password,
  ) async {
    await _authCubit.login(email, password);
    Modular.to.pushReplacementNamed('/home/');
  }
}
