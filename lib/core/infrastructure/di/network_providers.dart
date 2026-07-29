import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_token_storage.dart';
import '../../../features/auth/data/datasources/token_refresh_datasource.dart';
import '../../../features/auth/data/datasources/token_refresh_datasource_impl.dart';
import '../network/auth_interceptor.dart';
import '../network/http_client.dart' as app_http;

final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return AuthTokenStorage();
});

/// A minimal, *bare* Dio used exclusively for refreshing tokens. It does NOT
/// depend on [dioProvider] (no interceptor / no auth header), so this lets us
/// avoid the cycle dioProvider ↔ httpClientProvider ↔ tokenRefreshDatasource.
final _refreshDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final tokenRefreshDatasourceProvider =
    Provider<TokenRefreshDatasource>((ref) {
  final refreshDio = ref.watch(_refreshDioProvider);
  return TokenRefreshDatasourceImpl(app_http.HttpClient(refreshDio));
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final interceptor = AuthInterceptor(
    tokenStorage: ref.watch(authTokenStorageProvider),
    refreshDatasource: ref.watch(tokenRefreshDatasourceProvider),
    dio: dio,
  );
  dio.interceptors.add(interceptor);
  return dio;
});

final httpClientProvider = Provider<app_http.HttpClient>((ref) {
  return app_http.HttpClient(ref.watch(dioProvider));
});
