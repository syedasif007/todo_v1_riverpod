import 'package:dio/dio.dart';

import '../../../../core/common/result.dart';
import '../../domain/entities/todo.dart';
import '../../domain/failures/todo_failure.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';
import '../dtos/update_todo_dto.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDatasource _remote;

  const TodoRepositoryImpl(this._remote);

  @override
  Future<Result<TodoFailure, List<Todo>>> fetchTodoList() async {
    try {
      final dtoList = await _remote.fetchTodoList();
      final todos = dtoList.map((dto) => dto.toEntity()).toList();
      return SuccessResult<TodoFailure, List<Todo>>(todos);
    } on DioException catch (_) {
      return const FailureResult<TodoFailure, List<Todo>>(NetworkFailure());
    } catch (_) {
      return const FailureResult<TodoFailure, List<Todo>>(UnexpectedFailure());
    }
  }

  @override
  Future<Result<TodoFailure, Todo>> updateTodoCompletion({
    required String id,
    required bool isCompleted,
  }) async {
    try {
      final dto = await _remote.updateTodoCompletion(
        id: id,
        body: UpdateTodoDto(completed: isCompleted),
      );
      return SuccessResult<TodoFailure, Todo>(dto.toEntity());
    } on DioException catch (_) {
      return const FailureResult<TodoFailure, Todo>(NetworkFailure());
    } catch (_) {
      return const FailureResult<TodoFailure, Todo>(UnexpectedFailure());
    }
  }
}
