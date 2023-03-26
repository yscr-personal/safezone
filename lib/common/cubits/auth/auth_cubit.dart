import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unb/common/models/requests/login_request.dart';
import 'package:unb/common/models/user_model.dart';
import 'package:unb/common/services/protocols/i_auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthService _authService;
  final _logger = Modular.get<Logger>();

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> tryToHotLoadUser() async {
    emit(AuthLoading());
    try {
      final result = await _authService.fetchCurrentUser();
      if (result.isLeft) {
        throw result.left;
      }
      emit(AuthLoaded(user: result.right));
    } catch (exception, stackTrace) {
      _captureException(exception, stackTrace);
    }
  }

  Future<void> login(final String email, final String password) async {
    emit(AuthLoading());
    try {
      final result = await _authService.login(
        LoginRequest(email: email, password: password),
      );
      if (result.isLeft) {
        throw result.left;
      }
      emit(AuthLoaded(user: result.right));
    } catch (exception, stackTrace) {
      _captureException(exception, stackTrace);
    }
  }

  Future<void> logout() async {
    emit(AuthInitial());
  }

  _captureException(final exception, final stackTrace) async {
    _logger.e(exception.toString());
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
    emit(AuthError(message: exception.toString()));
  }
}
