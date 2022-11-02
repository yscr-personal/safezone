import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';

class SignupController {
  final _logger = Modular.get<Logger>();

  Future<bool> signUpUser(
    final String email,
    final String password,
  ) async {
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: email,
      };
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      return result.isSignUpComplete;
    } on AuthException catch (e) {
      _logger.e(e.message);
    }
    return false;
  }

  Future<bool> confirmUser(final String username, final String code) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: code,
      );
      return result.isSignUpComplete;
    } on AuthException catch (e) {
      safePrint(e.message);
    }
    return false;
  }
}
