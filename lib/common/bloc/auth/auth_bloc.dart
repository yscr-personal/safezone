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
      final token = _userPreferences.token;
      if (token == null) {
        emit(AuthInitial());
        return;
      }

      final userJson = await _httpService.get('/users/$token');
      if (userJson == null) {
        emit(AuthInitial());
        return;
      }

      final user = UserModel.fromJson(userJson);
      emit(AuthLoaded(user: user));
    });
    on<LoginEvent>((event, emit) async {
      if (state is AuthLoaded) {
        await _userPreferences.saveToken(event.user);
        emit(AuthLoaded(user: event.user));
      }
    });
    on<LogoutEvent>((event, emit) {
      if (state is AuthLoaded) {
        _userPreferences.deleteToken();
        emit(AuthInitial());
      }
    });
  }
}
