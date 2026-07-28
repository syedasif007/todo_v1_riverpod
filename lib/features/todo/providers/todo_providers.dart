import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_provider.dart';
import '../application/usecases/fetch_todo_list_usecase.dart';
import '../data/datasources/todo_remote_datasource.dart';
import '../data/datasources/todo_remote_datasource_impl.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../presentation/controllers/todo_controller.dart';

final todoRemoteDatasourceProvider = Provider<TodoRemoteDatasource>((ref) {
  final http = ref.watch(httpClientProvider);
  return TodoRemoteDatasourceImpl(http);
});

final todoRepositoryProvider = Provider((ref) {
  final remote = ref.watch(todoRemoteDatasourceProvider);
  return TodoRepositoryImpl(remote);
});

final fetchTodoListUseCaseProvider = Provider<FetchTodoListUseCase>((ref) {
  final repo = ref.watch(todoRepositoryProvider);
  return FetchTodoListUseCase(repo);
});

final todoControllerProvider =
    AsyncNotifierProvider<TodoController, TodoControllerState>(
      TodoController.new,
    );
