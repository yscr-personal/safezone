import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';

class LoginController {
  final _logger = Modular.get<Logger>();

  Future<bool> signInUser(final String username, final String password) async {
    _logger.i('[LoginController] - signInUser: $username');
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );

      return result.isSignedIn;
    } on AuthException catch (e) {
      _logger.e(e.message);
    }

    return false;
  }
}
