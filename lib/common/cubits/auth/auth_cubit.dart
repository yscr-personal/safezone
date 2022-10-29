import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unb/common/interfaces/i_http_service.dart';
import 'package:unb/common/models/user_model.dart';
import 'package:unb/common/storage/user_preferences.dart';

part 'auth_state.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final IHttpService _httpService;
  final UserPreferences _userPreferences;

  AuthCubit(this._userPreferences, this._httpService) : super(AuthInitial());

  Future<void> tryToLoadUserFromStorage() async {
    emit(AuthLoading());
    try {
      final token = await _userPreferences.token;
      if (token == null) {
        throw const AuthException('Token not found');
      }
      final user = await fetchUser(token);
      emit(AuthLoaded(user: user));
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    }
  }

  Future<void> login(final String email, final String password) async {
    emit(AuthLoading());
    try {
      final id = '$email@$password'.hashCode % 10;
      final user = await fetchUser(id.toString());
      await _userPreferences.saveToken(user);
      emit(AuthLoaded(user: user));
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _userPreferences.deleteToken();
      emit(AuthInitial());
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    }
  }

  Future<UserModel> fetchUser(final String id) async {
    final userJson = await _httpService.get('/users/$id');
    if (userJson == null) {
      throw const AuthException('Failed to fetch user');
    }
    final user = UserModel.fromJson(userJson);
    return user;
  }
}
