import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unb/common/clients/safezone_api/groups_service.dart';
import 'package:unb/common/models/group_model.dart';
import 'package:unb/common/models/user_model.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final _logger = Modular.get<Logger>();
  final GroupsService _groupsService;

  GroupCubit(this._groupsService) : super(GroupInitial());

  Future<void> fetchGroups() async {
    emit(GroupLoading());
    try {
      final result = await _groupsService.getGroups();
      if (result.isLeft) {
        throw result.left;
      }
      final groups = result.right;
      emit(
        GroupLoaded(
          groups: groups,
          selected: groups.isNotEmpty ? groups.first : null,
        ),
      );
    } catch (exception, stackTrace) {
      _captureException(exception, stackTrace);
    }
  }

  void selectGroup(final String groupId) {
    if (state is! GroupLoaded) return;

    final groupLoadedState = state as GroupLoaded;
    final groups = groupLoadedState.groups;

    final selected = groups.firstWhere(
      (element) => element.id == groupId,
      orElse: () => groups.first,
    );

    emit(
      GroupLoaded(
        groups: groups,
        selected: selected,
      ),
    );
  }

  Future<void> updateGroupMemberLocation(
    final String memberId, {
    required final double latitude,
    required final double longitude,
  }) async {
    if (state is! GroupLoaded) return;

    final groupLoadedState = state as GroupLoaded;
    final groups = groupLoadedState.groups;
    final group = groupLoadedState.selected!;

    _logger.d(
      'Updating user $memberId to location [$latitude, $longitude] for ${group.name}',
    );

    final newMember = UserModel.copyWith(
      group.members!.firstWhere((e) => e.id == memberId),
      lastLatitude: latitude,
      lastLongitude: longitude,
    );

    final newGroup = GroupModel.copyWith(
      group,
      members:
          group.members!.map((e) => e.id == memberId ? newMember : e).toList(),
    );

    emit(
      GroupLoaded(
        groups: groups.map((g) => g.id == group.id ? newGroup : g).toList(),
        selected: newGroup,
      ),
    );
  }

  _captureException(
    final exception,
    final stackTrace,
  ) async {
    _logger.e(exception.toString());
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
    emit(GroupError(message: exception.toString()));
  }
}
