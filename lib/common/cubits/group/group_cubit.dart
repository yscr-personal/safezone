import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unb/common/business_exception.dart';
import 'package:unb/common/interfaces/i_http_service.dart';
import 'package:unb/common/models/user_model.dart';

part 'group_state.dart';

class GroupException extends BusinessException {
  const GroupException(super.message);
}

class GroupCubit extends Cubit<GroupState> {
  final IHttpService _httpService;

  GroupCubit(this._httpService) : super(GroupInitial());

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
    }
  }
}
