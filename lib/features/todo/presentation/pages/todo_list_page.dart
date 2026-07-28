import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/todo_providers.dart';

class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(todoControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (state) {
          if (state.failure != null) {
            return Center(child: Text(state.failure.toString()));
          }

          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (_, index) {
              final todo = state.todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                leading: Checkbox(value: todo.isCompleted, onChanged: null),
              );
            },
          );
        },
      ),
    );
  }
}
