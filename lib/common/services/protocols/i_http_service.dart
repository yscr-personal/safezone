abstract class IHttpService {
  Future<T> get<T>(
    final String url, {
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  });

  Future<T> post<T>(
    final String url, {
    final Map<String, String>? headers,
    final dynamic body,
  });

  Future<T> put<T>(
    final String url, {
    final Map<String, String>? headers,
    final dynamic body,
  });

  Future<T> delete<T>(
    final String url, {
    final Map<String, String>? headers,
  });
}
