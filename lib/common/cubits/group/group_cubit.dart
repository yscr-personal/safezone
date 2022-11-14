import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unb/common/business_exception.dart';
import 'package:unb/common/interfaces/i_http_service.dart';
import 'package:unb/common/models/user_model.dart';

part 'group_state.dart';

class GroupException extends BusinessException {
  const GroupException(super.message);
}

class GroupCubit extends Cubit<GroupState> {
  final IHttpService _httpService;
  final Logger _logger;

  GroupCubit(this._httpService, this._logger) : super(GroupInitial());

  Future<void> fetchGroup() async {
    emit(GroupLoading());
    try {
      final groupJson = await _httpService.get('/users');
      if (groupJson == null) {
        throw const GroupException('Failed to fetch group');
      }
      final group =
          groupJson.map<UserModel>((json) => UserModel.fromJson(json)).toList();
      emit(GroupLoaded(group: group));
    } on GroupException catch (e) {
      emit(GroupError(message: e.message));
    } catch (exception, stackTrace) {
      _logger.e(exception.toString());
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      emit(GroupError(message: exception.toString()));
    }
  }

  Future<void> updateGroupLocation() async {
    if (state is GroupLoaded) {
      final group = (state as GroupLoaded).group;
      final updated = group[Random().nextInt(group.length)];
      _logger.d('Updating location for ${updated.name}');
      final newGroup = group
          .map((e) => e == updated
              ? UserModel(
                  id: e.id,
                  name: e.name,
                  email: e.email,
                  avatarUrl: e.avatarUrl,
                  address: UserAddressModel(
                    street: e.address!.street,
                    suite: e.address!.suite,
                    city: e.address!.city,
                    zipcode: e.address!.zipcode,
                    geo: UserAddressGeoModel(
                      lat: (double.parse(e.address!.geo.lat) +
                              Random().nextDouble() * 0.02)
                          .toString(),
                      lng: (double.parse(e.address!.geo.lng) +
                              Random().nextDouble() * 0.02)
                          .toString(),
                    ),
                  ),
                )
              : e)
          .toList();
      emit(GroupLoaded(group: newGroup));
    }
  }
}
