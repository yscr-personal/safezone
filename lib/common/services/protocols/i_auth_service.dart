import 'package:either_dart/either.dart';
import 'package:unb/common/models/requests/login_request.dart';
import 'package:unb/common/models/requests/register_request.dart';
import 'package:unb/common/models/user_model.dart';

abstract class IAuthService {
  Future<Either<Exception, UserModel>> login(final LoginRequest request);

  Future<Either<Exception, UserModel>> fetchCurrentUser();

  Future<Either<Exception, bool>> register(final RegisterRequest request);

  Future<String?> fetchJwtToken();
}
