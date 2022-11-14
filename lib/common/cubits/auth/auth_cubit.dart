import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unb/common/business_exception.dart';
import 'package:unb/common/interfaces/i_auth_service.dart';

part 'auth_state.dart';

class AuthException extends BusinessException {
  const AuthException(super.message);
}

class AuthCubit extends Cubit<AuthState> {
  final IAuthService _authService;
  final Logger _logger;

  AuthCubit(
    this._authService,
    this._logger,
  ) : super(AuthInitial());

  Future<void> tryToHotLoadUser() async {
    emit(AuthLoading());
    try {
      final hasSession = await _authService.fetchSession();
      if (hasSession) {
        final user = await _authService.fetchCurrentUser();
        emit(AuthLoaded(user: user));
      } else {
        throw const AuthException('User has no session');
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } on UserNotFoundException catch (e) {
      emit(AuthError(message: e.message));
    } catch (exception, stackTrace) {
      _logger.e(exception.toString());
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      emit(AuthError(message: exception.toString()));
    }
  }

  Future<void> login(final String email, final String password) async {
    emit(AuthLoading());
    try {
      final success = await _authService.login(
        email,
        password,
        rememberDevice: true,
      );
      if (success) {
        final user = await _authService.fetchCurrentUser();
        emit(AuthLoaded(user: user));
      } else {
        throw const AuthException('Failed to login');
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (exception, stackTrace) {
      _logger.e(exception.toString());
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      emit(AuthError(message: exception.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authService.logout();
      emit(AuthInitial());
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (exception, stackTrace) {
      _logger.e(exception.toString());
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      emit(AuthError(message: exception.toString()));
    }
  }
}
