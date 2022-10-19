import 'package:dio/dio.dart';
import 'package:unb/common/interfaces/i_http_service.dart';

class LoginController {
  const LoginController(
    this._httpService,
  );

  final IHttpService _httpService;

  Future<Response> authenticateUser(
      final String email, final String password) async {
    final result = await _httpService.post(
      '/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    return result;
  }
}
