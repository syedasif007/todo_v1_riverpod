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
      final response = await _http.dio.get<List<dynamic>>('todos');
      final data = response.data;

      if (data == null) {
        return const [];
      }

      return data
          .map((item) => TodoDto.fromJson(item as Map<String, dynamic>))
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
    } catch (_) {
      rethrow;
    }
  }
}
