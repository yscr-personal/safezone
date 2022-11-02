import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';

class LoginController {
  final _logger = Modular.get<Logger>();
  final _authCubit = Modular.get<AuthCubit>();

  Future<bool> signInUser(final String username, final String password) async {
    _logger.i('[LoginController] - signInUser: $username');
    try {
      await _authCubit.login(username, password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
