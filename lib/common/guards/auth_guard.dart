import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';

class AuthGuard extends RouteGuard {
  final _logger = Modular.get<Logger>();

  AuthGuard() : super(redirectTo: '/auth/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final ok = await _isLoggedIn();
    _logger.i('[AuthGuard] - Allow access to $path: $ok');
    return Future.value(ok);
  }

  Future<bool> _isLoggedIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      return session.isSignedIn;
    } catch (e) {
      return false;
    }
  }
}
