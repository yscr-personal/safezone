import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';

class AuthGuard extends RouteGuard {
  final AuthBloc authBloc = Modular.get();

  AuthGuard() : super(redirectTo: '/auth/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) {
    return Future.value(authBloc.state is AuthInitial);
  }
}
