import 'package:dio/dio.dart';

import '../../../../core/network/http_client.dart';
import '../datasources/auth_remote_datasource.dart';
import '../dtos/user_dto.dart';
import '../../domain/failures/auth_failure.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final HttpClient _http;

  const AuthRemoteDatasourceImpl(this._http);

  @override
  Future<UserDto> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _http.dio.post<Map<String, dynamic>>(
        'auth/login',
        data: {'username': email, 'password': password},
      );

      final data = response.data;

      if (data == null) {
        throw const UnexpectedFailure();
      }

      return UserDto.fromJson(data);
    } on DioException catch (e) {
      final isNetwork =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown;

      if (isNetwork) {
        throw const NetworkFailure();
      }

      final status = e.response?.statusCode;

      if (status == 400 || status == 401 || status == 403) {
        throw const InvalidCredentialsFailure();
      }

      throw const UnexpectedFailure();
    } catch (_) {
      throw const UnexpectedFailure();
    }
  }
}
