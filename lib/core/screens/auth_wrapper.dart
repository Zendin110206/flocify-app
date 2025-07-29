// Path: lib/core/screens/auth_wrapper.dart (Versi Perbaikan 2.0)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/core/screens/main_screen.dart';
import 'package:proyek_flocify/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/on_boarding_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/welcome_screen.dart';

// Provider untuk stream otentikasi Firebase
final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Provider BARU untuk mengelola status splash screen
final splashFinishedProvider = StateProvider<bool>((ref) => false);

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Memulai timer saat widget pertama kali dibuat
    Future.delayed(const Duration(seconds: 3), () {
      // Pastikan widget masih ada di tree sebelum update state
      if (mounted) {
        ref.read(splashFinishedProvider.notifier).state = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSplashFinished = ref.watch(splashFinishedProvider);

    if (!isSplashFinished) {
      // Selama timer berjalan, PASTI tampilkan SplashScreen
      return const SplashScreen();
    }

    // Setelah timer selesai, baru kita evaluasi state login dan onboarding
    final authState = ref.watch(authStateChangesProvider);
    final onboardingPrefs = ref.watch(sharedPreferencesProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (user) {
        return onboardingPrefs.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) =>
              Scaffold(body: Center(child: Text('Error Prefs: $err'))),
          data: (prefs) {
            final onboardingRepository = OnboardingRepository(prefs);
            final isOnboardingComplete = onboardingRepository
                .isOnboardingComplete();

            if (user != null) {
              return const MainScreen();
            } else {
              if (isOnboardingComplete) {
                return const WelcomeScreen();
              } else {
                return const OnboardingScreen();
              }
            }
          },
        );
      },
    );
  }
}
