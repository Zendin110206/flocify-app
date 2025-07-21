// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      ref.read(loginControllerProvider.notifier).signIn(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Awasi state dari controller, jika error tampilkan pesan
    ref.listen<AsyncValue>(loginControllerProvider, (previous, next) {
      // Cek jika state berikutnya adalah error
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }

      // Cek jika state sebelumnya sedang loading, dan state berikutnya sudah tidak loading & tidak error
      if (previous is AsyncLoading && !next.isLoading && !next.hasError) {
        // Login berhasil!
        // Kita "buang" semua layar di atas AuthWrapper (yaitu WelcomeScreen & LoginScreen)
        // agar AuthWrapper bisa menampilkan MainScreen yang sudah disiapkannya.
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login Flocify')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
