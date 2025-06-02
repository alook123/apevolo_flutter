import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/login_provider.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '用户名'),
                onChanged: notifier.setUsername,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: '密码'),
                obscureText: true,
                onChanged: notifier.setPassword,
              ),
              if (state.error != null) ...[
                const SizedBox(height: 16),
                Text(state.error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: state.isLoading ? null : () => notifier.login(),
                child: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
