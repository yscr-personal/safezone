import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unb/common/interfaces/i_http_service.dart';
import 'package:unb/common/models/user_model.dart';
import 'package:unb/common/storage/user_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserPreferences _userPreferences;
  final IHttpService _httpService;

  AuthBloc(this._userPreferences, this._httpService) : super(AuthInitial()) {
    on<LoadUserTokenEvent>((event, emit) async {
      final token = await _userPreferences.token;
      if (token == null) {
        emit(const AuthFailed(message: 'Token not found'));
        return;
      }

      final userJson = await _httpService.get('/users/$token');
      if (userJson == null) {
        emit(const AuthFailed(message: 'Failed to fetch user'));
        return;
      }

      final user = UserModel.fromJson(userJson);
      emit(AuthLoaded(user: user));
    });
    on<LoginEvent>((event, emit) async {
      final id = '${event.email}@${event.password}'.hashCode % 10;
      final userJson = await _httpService.get('/users/$id');
      if (userJson == null) {
        emit(const AuthFailed(message: 'Failed to fetch user'));
        return;
      }
      final user = UserModel.fromJson(userJson);
      await _userPreferences.saveToken(user);
      emit(AuthLoaded(user: user));
    });
    on<LogoutEvent>((event, emit) {
      _userPreferences.deleteToken();
      emit(AuthInitial());
    });
  }
}
