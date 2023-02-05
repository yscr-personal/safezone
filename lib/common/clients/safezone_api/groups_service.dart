import 'package:either_dart/either.dart';
import 'package:unb/common/models/group_model.dart';
import 'package:unb/common/services/protocols/i_http_service.dart';
import 'package:unb/common/storage/user_preferences.dart';

class GroupsService {
  final IHttpService _httpService;
  final UserPreferences _userPreferences;

  GroupsService(
    this._httpService,
    this._userPreferences,
  );

  Future<Either<Exception, List<GroupModel>>> getGroups() async {
    final token = await _userPreferences.token;
    if (token == null) {
      return Left(Exception('No token found'));
    }

    try {
      final groups = await _httpService.get(
        '/groups',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return Right(
        (groups as List<dynamic>)
            .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
