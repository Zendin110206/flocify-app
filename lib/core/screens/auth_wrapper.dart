// lib/core/screens/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/core/screens/main_screen.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import 'package:proyek_flocify/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/on_boarding_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/role_selection_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:proyek_flocify/features/users/presentation/providers/user_providers.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/verification_screen.dart';

// Provider ini hanya untuk mengelola durasi splash screen, tidak lebih.
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
    // Timer untuk splash screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        ref.read(splashFinishedProvider.notifier).state = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tampilkan splash screen jika belum selesai
    final isSplashFinished = ref.watch(splashFinishedProvider);
    if (!isSplashFinished) {
      return const SplashScreen();
    }

    // 2. Pantau status otentikasi dari Firebase Auth
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => _buildLoadingScreen(),
      error: (err, stack) => _buildErrorScreen(err.toString()),
      data: (user) {
        // 3. Jika TIDAK ADA user yang login
        if (user == null) {
          // Cek apakah pengguna pernah melewati onboarding visual
          final onboardingPrefs = ref.watch(sharedPreferencesProvider);
          return onboardingPrefs.when(
            loading: () => _buildLoadingScreen(),
            error: (err, stack) => _buildErrorScreen(err.toString()),
            data: (prefs) {
              final onboardingRepository = OnboardingRepository(prefs);
              final hasSeenOnboarding = onboardingRepository
                  .isOnboardingComplete();

              // Jika sudah pernah, langsung ke Welcome Screen (login/signup)
              // Jika belum, tampilkan Onboarding visual pertama kali
              return hasSeenOnboarding
                  ? const WelcomeScreen()
                  : const OnboardingScreen();
            },
          );
        }
        // 4. Jika ADA user yang login, kita WAJIB cek profilnya di Firestore
        else {
          final isEmailVerified = user.emailVerified;

          // Jika email BELUM diverifikasi, TAMPILKAN LAYAR VERIFIKASI.
          // Tidak peduli status profilnya apa, verifikasi adalah yang utama.
          if (!isEmailVerified) {
            // Kita juga perlu me-refresh state user secara berkala untuk mengecek
            // apakah dia sudah mengklik link di emailnya.
            // Cara sederhana adalah dengan menambahkan tombol "Saya sudah verifikasi"
            // di VerificationScreen yang memanggil `user.reload()`.
            return VerificationScreen(email: user.email!);
          }
          
          // Pantau profil dari StreamProvider yang baru kita buat
          final userProfileState = ref.watch(userProfileStreamProvider);

          return userProfileState.when(
            loading: () => _buildLoadingScreen(),
            error: (err, stack) => _buildErrorScreen(err.toString()),
            data: (profile) {
              // Jika profil belum ada/belum termuat (misal, koneksi lambat)
              if (profile == null) {
                return _buildLoadingScreen();
              }

              // Jika profil SUDAH LENGKAP (`isNewUser` sudah false)
              if (!profile.isNewUser) {
                return const MainScreen();
              }
              // Jika profil BELUM LENGKAP (`isNewUser` masih true)
              // Ini adalah kasus di mana pengguna mendaftar tetapi belum selesai
              // memilih peran. Kita PAKSA mereka ke RoleSelectionScreen.
              else {
                return const RoleSelectionScreen();
              }
            },
          );
        }
      },
    );
  }

  // Helper widget agar kode lebih bersih
  Widget _buildLoadingScreen() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Terjadi kesalahan fatal: $error'),
        ),
      ),
    );
  }
}
