import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';

class AuthGuard extends RouteGuard {
  final Logger logger = Modular.get();
  final AuthCubit auth2cubit = Modular.get();

  AuthGuard() : super(redirectTo: '/auth/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final ok = await _isLoggedIn();
    logger.i('[AuthGuard] - Allow access to $path: $ok');
    return Future.value(ok);
  }

  Future<bool> _isLoggedIn() async {
    bool ok = auth2cubit.state is AuthLoaded;
    if (ok) {
      final AuthLoaded state = auth2cubit.state as AuthLoaded;
      ok = state.user.id != '';
    }
    return ok;
  }
}
