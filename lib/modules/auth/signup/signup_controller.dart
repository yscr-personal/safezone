import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unb/common/services/protocols/i_auth_service.dart';

class SignupController {
  final _logger = Modular.get<Logger>();
  final _authService = Modular.get<IAuthService>();

  Future<bool> signUpUser(
    final String email,
    final String password,
    final String username,
    final String name,
  ) async {
    try {
      final result = await _authService.register(
        RegisterRequest(
          email: email,
          username: username,
          name: name,
          password: password,
        ),
      );
      if (result.isRight) {
        return true;
      }
      throw result.left;
    } catch (exception, stackTrace) {
      _logger.e(exception.toString());
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
    return false;
  }
}
