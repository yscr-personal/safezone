part of 'websocket_cubit.dart';

abstract class WebsocketState extends Equatable {
  const WebsocketState();

  @override
  List<Object> get props => [];
}

class WebsocketInitial extends WebsocketState {}

class WebsocketLoading extends WebsocketState {}

class WebsocketLoaded extends WebsocketState {
  final Socket socket;

  const WebsocketLoaded({required this.socket});

  @override
  List<Object> get props => [socket];
}

class WebsocketError extends WebsocketState {
  final String message;

  const WebsocketError({required this.message});

  @override
  List<Object> get props => [message];
}
