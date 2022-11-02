abstract class IHttpService {
  Future get(
    final String url, {
    final Map<String, String>? headers,
    final Map<String, String>? queryParameters,
  });

  Future post(
    final String url, {
    final Map<String, String>? headers,
    final dynamic body,
  });

  Future put(
    final String url, {
    final Map<String, String>? headers,
    final dynamic body,
  });

  Future delete(
    final String url, {
    final Map<String, String>? headers,
  });
}
