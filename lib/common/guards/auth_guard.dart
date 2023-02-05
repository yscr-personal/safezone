import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';

class AuthGuard extends RouteGuard {
  final _logger = Modular.get<Logger>();
  final _authCubit = Modular.get<AuthCubit>();

  AuthGuard() : super(redirectTo: '/auth/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final ok = await _isLoggedIn();
    _logger.i('[AuthGuard] - Allow access to $path: $ok');
    return Future.value(ok);
  }

  Future<bool> _isLoggedIn() async {
    return _authCubit.state is AuthLoaded;
  }
}
