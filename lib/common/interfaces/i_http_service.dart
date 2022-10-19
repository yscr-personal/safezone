abstract class IHttpService {
  Future get(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  Future post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future delete(
    String url, {
    Map<String, String>? headers,
  });
}
