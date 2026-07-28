import '../dtos/todo_dto.dart';

abstract class TodoRemoteDatasource {
  Future<List<TodoDto>> fetchTodoList();
}
