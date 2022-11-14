import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
    } catch (exception, stackTrace) {
      _logger.e(exception.toString());
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
    return false;
  }

  Future<bool> confirmUser(final String username, final String code) async {
    try {
      return await _authService.confirmRegistration(username, code);
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
