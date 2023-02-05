import 'package:either_dart/either.dart';
import 'package:unb/common/models/user_model.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });
}

class RegisterRequest {
  final String email;
  final String username;
  final String name;
  final String password;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.name,
    required this.password,
  });
}

abstract class IAuthService {
  Future<Either<Exception, UserModel>> login(final LoginRequest request);

  Future<Either<Exception, UserModel>> fetchCurrentUser();

  Future<Either<Exception, bool>> register(final RegisterRequest request);

  Future<String?> fetchJwtToken();
}
