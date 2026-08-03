import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/usecases/fetch_todo_list_usecase.dart';
import '../../domain/entities/todo.dart';
import '../../domain/failures/todo_failure.dart';
import '../../providers/todo_providers.dart';

class TodoControllerState {
  final List<Todo> todos;
  final TodoFailure? failure;

  const TodoControllerState({required this.todos, this.failure});

  const TodoControllerState.initial() : this(todos: const []);

  TodoControllerState copyWith({List<Todo>? todos, TodoFailure? failure}) {
    return TodoControllerState(todos: todos ?? this.todos, failure: failure);
  }
}

class TodoController extends AsyncNotifier<TodoControllerState> {
  late FetchTodoListUseCase _fetchTodoListUseCase;

  @override
  Future<TodoControllerState> build() async {
    _fetchTodoListUseCase = ref.read(fetchTodoListUseCaseProvider);
    return await _loadTodos();
  }

  Future<TodoControllerState> _loadTodos() async {
    state = const AsyncLoading();

    final result = await _fetchTodoListUseCase();

    return result.fold(
      (failure) => TodoControllerState.initial().copyWith(failure: failure),
      (todos) => TodoControllerState.initial().copyWith(todos: todos),
    );
  }

  Future<void> refresh() async {
    state = AsyncValue.data(await _loadTodos());
  }

  void toggleTodoCompletion(Todo todo) {
    final current = state.value; // TodoControllerState?
    if (current == null) return;

    final updatedTodos = [
      for (final t in current.todos)
        if (t.id == todo.id) t.copyWith(isCompleted: !t.isCompleted) else t,
    ];

    state = AsyncValue.data(current.copyWith(todos: updatedTodos));

    // if (state.value == null) return;

    // state = AsyncValue.data(
    //   state.value!.copyWith(todos: [...state.value!.todos]),
    // );
  }
}
