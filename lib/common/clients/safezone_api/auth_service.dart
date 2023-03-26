import 'package:either_dart/either.dart';
import 'package:unb/common/models/requests/login_request.dart';
import 'package:unb/common/models/requests/register_request.dart';
import 'package:unb/common/models/user_model.dart';
import 'package:unb/common/services/protocols/i_auth_service.dart';
import 'package:unb/common/services/protocols/i_http_service.dart';
import 'package:unb/common/storage/user_preferences.dart';

class AuthService implements IAuthService {
  final IHttpService _httpService;
  final UserPreferences _userPreferences;

  AuthService(
    this._httpService,
    this._userPreferences,
  );

  @override
  Future<Either<Exception, UserModel>> login(final LoginRequest req) async {
    try {
      final result = await _httpService.post(
        '/auth/login',
        body: req.toJson(),
      );
      await _userPreferences.saveToken(result['access_token']);
      return Right(UserModel.fromJson(result));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> register(final RegisterRequest req) async {
    try {
      return Right(
        await _httpService.post(
          '/auth/register',
          body: req.toJson(),
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<String?> fetchJwtToken() async {
    return await _userPreferences.token;
  }

  @override
  Future<Either<Exception, UserModel>> fetchCurrentUser() async {
    final token = await fetchJwtToken();
    if (token == null) {
      return Left(Exception('No token found'));
    }

    try {
      final user = await _httpService.get(
        '/users/me',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return Right(UserModel.fromJson(user));
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
