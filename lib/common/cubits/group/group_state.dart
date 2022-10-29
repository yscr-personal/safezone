part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<UserModel> group;

  const GroupLoaded({required this.group});

  @override
  List<Object> get props => [group];
}

class GroupError extends GroupState {
  final String message;

  const GroupError({required this.message});

  @override
  List<Object> get props => [message];
}
