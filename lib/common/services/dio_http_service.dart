import 'package:dio/dio.dart';
import 'package:unb/common/interfaces/i_http_service.dart';

class DioHttpService implements IHttpService {
  final Dio _dio;

  const DioHttpService(this._dio);

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) {
    return _dio.get<T>(
      url,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );
  }

  @override
  Future<Response<T>> post<T>(
    String url, {
    Map<String, String>? headers,
    body,
  }) {
    return _dio.post<T>(
      url,
      data: body,
      options: Options(
        headers: headers,
      ),
    );
  }

  @override
  Future<Response<T>> put<T>(
    String url, {
    Map<String, String>? headers,
    body,
  }) {
    return _dio.put<T>(
      url,
      data: body,
      options: Options(
        headers: headers,
      ),
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
  }) {
    return _dio.delete<T>(
      url,
      options: Options(
        headers: headers,
      ),
    );
  }
}
