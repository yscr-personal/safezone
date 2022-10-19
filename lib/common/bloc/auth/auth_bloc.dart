import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unb/common/models/user_model.dart';
import 'package:unb/common/storage/user_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserPreferences _userPreferences;

  AuthBloc(this._userPreferences) : super(AuthInitial()) {
    on<LoadUserTokenEvent>((event, emit) {
      final token = _userPreferences.token;
      emit(token != null
          ? AuthLoaded(user: UserModel(id: token))
          : AuthInitial());
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
