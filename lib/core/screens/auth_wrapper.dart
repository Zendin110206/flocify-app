// lib/core/screens/auth_wrapper.dart


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// HAPUS import LoginScreen dari sini
import 'package:proyek_flocify/core/screens/main_screen.dart';
// TAMBAHKAN import WelcomeScreen yang baru
import 'package:proyek_flocify/features/onboarding/presentation/screens/welcome_screen.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const MainScreen(); // Pengguna sudah login, arahkan ke dalam aplikasi
        }
        // JIKA PENGGUNA BELUM LOGIN, arahkan ke WelcomeScreen
        return const WelcomeScreen(); 
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const Scaffold(body: Center(child: Text('Terjadi error'))),
    );
  }
}