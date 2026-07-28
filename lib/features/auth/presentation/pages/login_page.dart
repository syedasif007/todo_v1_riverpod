import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController(text: 'emilys');
  final _password = TextEditingController(text: 'emilyspass');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(authControllerProvider.notifier)
                    .login(email: _email.text, password: _password.text);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 12),

            state.when(
              loading: () => const CircularProgressIndicator(),
              error: (_, _) => const Text('Unexpected error'),
              data: (s) {
                final user = s.user;
                if (user != null) return Text('Welcome: ${user.email}');
                if (s.failure != null) return const Text('Login failed');
                return const Text('Enter credentials');
              },
            ),
          ],
        ),
      ),
    );
  }
}
