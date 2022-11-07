import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/interfaces/i_auth_service.dart';

class SignupController {
  final _logger = Modular.get<Logger>();
  final _authService = Modular.get<IAuthService>();

  Future<bool> signUpUser(
    final String email,
    final String password,
  ) async {
    try {
      return await _authService.register(email, password);
    } catch (e) {
      _logger.e(e.toString());
    }
    return false;
  }

  Future<bool> confirmUser(final String username, final String code) async {
    try {
      return await _authService.confirmRegistration(username, code);
    } catch (e) {
      _logger.e(e.toString());
    }
    return false;
  }
}
