import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';

class AuthGuard extends RouteGuard {
  final Logger logger = Modular.get();
  final AuthBloc authBloc = Modular.get();

  AuthGuard() : super(redirectTo: '/auth/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    bool ok = authBloc.state is AuthLoaded;
    if (ok) {
      final AuthLoaded state = authBloc.state as AuthLoaded;
      ok = state.user.id != '';
    }

    logger.i('[AuthGuard] - Allow access to $path: $ok');
    return Future.value(ok);
  }
}
