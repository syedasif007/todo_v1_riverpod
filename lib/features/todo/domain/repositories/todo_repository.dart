import '../../../../core/error_handling/result.dart';
import '../entities/todo.dart';
import '../failures/todo_failure.dart';

abstract class TodoRepository {
  Future<Result<TodoFailure, List<Todo>>> fetchTodoList();
}
