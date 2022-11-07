import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:unb/common/interfaces/i_auth_service.dart';

class AwsAuthService implements IAuthService {
  @override
  Future<bool> login(
    final String username,
    final String password, {
    final bool rememberDevice = true,
  }) async {
    final result = await Amplify.Auth.signIn(
      username: username,
      password: password,
    );
    return result.isSignedIn;
  }

  @override
  Future<void> logout({final bool everywhere = false}) {
    return Amplify.Auth.signOut(
      options: SignOutOptions(
        globalSignOut: everywhere,
      ),
    );
  }

  @override
  Future<bool> register(final String username, final String password) async {
    final result = await Amplify.Auth.signUp(
      username: username,
      password: password,
      options: CognitoSignUpOptions(
        userAttributes: {
          CognitoUserAttributeKey.email: username,
        },
      ),
    );

    return result.isSignUpComplete;
  }

  @override
  Future<bool> confirmRegistration(
    final String username,
    final String confirmationCode,
  ) async {
    final result = await Amplify.Auth.confirmSignUp(
      username: username,
      confirmationCode: confirmationCode,
    );
    return result.isSignUpComplete;
  }

  @override
  Future<bool> fetchSession() async {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }

  @override
  Future<AuthUser> fetchCurrentUser() async {
    return await Amplify.Auth.getCurrentUser();
  }

  @override
  Future<bool> isLogged() {
    return fetchSession();
  }
}
