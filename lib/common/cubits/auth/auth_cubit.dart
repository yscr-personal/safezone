import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unb/common/business_exception.dart';
import 'package:unb/common/interfaces/i_auth_service.dart';

part 'auth_state.dart';

class AuthException extends BusinessException {
  const AuthException(super.message);
}

class AuthCubit extends Cubit<AuthState> {
  final IAuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

  Future<void> tryToHotLoadUser() async {
    emit(AuthLoading());
    try {
      final hasSession = await authService.fetchSession();
      if (hasSession) {
        final user = await authService.fetchCurrentUser();
        emit(AuthLoaded(user: user));
      } else {
        throw const AuthException('User has no session');
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } on UserNotFoundException catch (e) {
      emit(AuthError(message: e.message));
    }
  }

  Future<void> login(final String email, final String password) async {
    emit(AuthLoading());
    try {
      final success = await authService.login(
        email,
        password,
        rememberDevice: true,
      );
      if (success) {
        final user = await authService.fetchCurrentUser();
        emit(AuthLoaded(user: user));
      } else {
        throw const AuthException('Failed to login');
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authService.logout();
      emit(AuthInitial());
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
