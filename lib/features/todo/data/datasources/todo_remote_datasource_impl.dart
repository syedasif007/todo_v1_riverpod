import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/http_client.dart';
import '../datasources/todo_remote_datasource.dart';
import '../dtos/todo_dto.dart';

class TodoRemoteDatasourceImpl implements TodoRemoteDatasource {
  final HttpClient _http;

  const TodoRemoteDatasourceImpl(this._http);

  @override
  Future<List<TodoDto>> fetchTodoList() async {
    try {
      final response = await _http.dio.get<Map<String, dynamic>>('todos');
      final data = response.data;

      if (data == null) {
        return const [];
      }

      final rawList = data['todos'] as List<dynamic>?;
      if (rawList == null) {
        return const [];
      }

      return rawList
          .cast<Map<String, dynamic>>()
          .map((item) => TodoDto.fromJson(item))
          .toList();
    } on DioException catch (e) {
      final isNetwork =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown;

      if (isNetwork) {
        throw DioException(
          requestOptions: e.requestOptions,
          type: DioExceptionType.unknown,
        );
      }

      rethrow;
    }
  }
}
