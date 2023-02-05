import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:unb/common/environment_config.dart';
import 'package:unb/common/services/protocols/i_http_service.dart';

class DioHttpService implements IHttpService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvironmentConfig.SAFEZONE_API_URL,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: 'application/json',
      validateStatus: (status) => status! < 500,
    ),
  );

  DioHttpService() {
    _dio.interceptors.add(PrettyDioLogger());
    _dio.interceptors.add(RetryInterceptor(dio: _dio));
  }

  @override
  Future<T> get<T>(
    final String url, {
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  }) async {
    final response = await _dio.get<T>(
      url,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );

    final T? data = response.data;
    if (response.statusCode == 200 && data != null) {
      return data;
    }

    throw DioError(
      requestOptions: response.requestOptions,
      response: response,
    );
  }

  @override
  Future<T> post<T>(
    final String url, {
    final Map<String, String>? headers,
    final body,
  }) async {
    final response = await _dio.post<T>(
      url,
      data: body,
      options: Options(
        headers: headers,
      ),
    );

    final T? data = response.data;
    if ([200, 201].contains(response.statusCode) && data != null) {
      return data;
    }

    throw DioError(
      requestOptions: response.requestOptions,
      response: response,
    );
  }

  @override
  Future<T> put<T>(
    final String url, {
    final Map<String, String>? headers,
    final body,
  }) async {
    final response = await _dio.put<T>(
      url,
      data: body,
      options: Options(
        headers: headers,
      ),
    );

    final T? data = response.data;
    if (response.statusCode == 200 && data != null) {
      return data;
    }

    throw DioError(
      requestOptions: response.requestOptions,
      response: response,
    );
  }

  @override
  Future<T> delete<T>(
    final String url, {
    final Map<String, String>? headers,
  }) async {
    final response = await _dio.delete<T>(
      url,
      options: Options(
        headers: headers,
      ),
    );

    final T? data = response.data;
    if (response.statusCode == 200 && data != null) {
      return data;
    }

    throw DioError(
      requestOptions: response.requestOptions,
      response: response,
    );
  }
}
