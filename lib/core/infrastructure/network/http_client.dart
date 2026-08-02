import 'package:dio/dio.dart';

/// Centralized HTTP client that owns the [Dio] instance and its app-wide
/// configuration (base URL, timeouts, content-type). Concrete network
/// concerns — base options, request/response transforms, common headers —
/// should be configured here so datasources stay transport-agnostic.
///
/// The [Dio] is exposed so lower-level consumers (such as the auth
/// interceptor when retrying a failed request) can reuse the same
/// connection pool / interceptors.
class HttpClient {
  HttpClient({
    String baseUrl = 'https://dummyjson.com/',
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 10),
    Map<String, String>? defaultHeaders,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           sendTimeout: sendTimeout,
           headers: {
             'Accept': 'application/json',
             'Content-Type': 'application/json',
             ...?defaultHeaders,
           },
           responseType: ResponseType.json,
         ),
       );

  /// The configured [Dio] used for all HTTP traffic. Add interceptors
  /// (auth, logging, retry, etc.) to this instance.
  final Dio dio;
}
