import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/interfaces/i_auth_service.dart';

class AuthGuard extends RouteGuard {
  final _logger = Modular.get<Logger>();
  final _authService = Modular.get<IAuthService>();

  AuthGuard() : super(redirectTo: '/auth/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final ok = await _isLoggedIn();
    _logger.i('[AuthGuard] - Allow access to $path: $ok');
    return Future.value(ok);
  }

  Future<bool> _isLoggedIn() async {
    return await _authService.isLogged();
  }
}
