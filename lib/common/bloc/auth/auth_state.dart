part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoaded extends AuthState {
  final UserModel user;

  const AuthLoaded({required this.user});

  @override
  List<Object> get props => [user];
}
