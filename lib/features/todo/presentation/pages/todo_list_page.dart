import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/todo_providers.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/providers/auth_providers.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    // Clear persisted tokens + the in-memory controller state, then route
    // the user back to the login screen.
    await ref.read(authControllerProvider.notifier).logout();
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () =>
                ref.read(todoControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => _logout(context, ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(todoControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (state) {
          if (state.failure != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.failure.toString(), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(todoControllerProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (_, index) {
              final todo = state.todos[index];
              return ListTile(
                title: Text(todo.userId),
                subtitle: Text(todo.todo),
                leading: Checkbox(value: todo.isCompleted, onChanged: null),
              );
            },
          );
        },
      ),
    );
  }
}
