import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unb/common/business_exception.dart';

part 'auth_state.dart';

class AuthException extends BusinessException {
  const AuthException(super.message);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> tryToLoadUserFromStorage() async {
    emit(AuthLoading());
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        emit(AuthLoaded(user: user));
      } else {
        throw const AuthException('User has no session');
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    }
  }

  Future<void> login(final String email, final String password) async {
    emit(AuthLoading());
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      if (result.isSignedIn) {
        await Amplify.Auth.rememberDevice();
        final user = await Amplify.Auth.getCurrentUser();
        emit(AuthLoaded(user: user));
      } else {
        throw const AuthException('Failed to login');
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await Amplify.Auth.signOut();
      emit(AuthInitial());
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
