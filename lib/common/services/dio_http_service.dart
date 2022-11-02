import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:unb/common/environment_config.dart';
import 'package:unb/common/interfaces/i_http_service.dart';

class DioHttpService implements IHttpService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvironmentConfig.BACKEND_URL,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: 'application/json',
      validateStatus: (status) => status! < 500,
    ),
  );

  DioHttpService() {
    _dio.interceptors.add(PrettyDioLogger());
  }

  @override
  Future get(
    final String url, {
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  }) async {
    final response = await _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    }
  }

  @override
  Future post(
    final String url, {
    final Map<String, String>? headers,
    final body,
  }) async {
    final response = await _dio.post(
      url,
      data: body,
      options: Options(
        headers: headers,
      ),
    );

    if ([200, 201].contains(response.statusCode)) {
      return response.data;
    }
  }

  @override
  Future put(
    final String url, {
    final Map<String, String>? headers,
    final body,
  }) async {
    final response = await _dio.put(
      url,
      data: body,
      options: Options(
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    }
  }

  @override
  Future delete(
    final String url, {
    final Map<String, String>? headers,
  }) async {
    final response = await _dio.delete(
      url,
      options: Options(
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    }
  }
}
