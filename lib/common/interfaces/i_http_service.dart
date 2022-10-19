import 'package:dio/dio.dart';

abstract class IHttpService {
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  Future<Response<T>> post<T>(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<Response<T>> put<T>(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
  });
}
