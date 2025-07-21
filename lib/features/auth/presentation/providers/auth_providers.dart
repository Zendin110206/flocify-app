// lib/features/auth/presentation/providers/auth_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

/// Provides the UID of the currently logged-in user.
///
/// In the future, this will be connected to a real Firebase Auth state listener.
/// For now, it returns a hardcoded ID for development purposes.
final currentUserIdProvider = Provider<String?>((ref) {
  // ! Placeholder: Ganti dengan logika autentikasi yang sebenarnya nanti.
  return 'Muhammad Zaenal Abidin Abdurrahman'; // Gunakan ID yang lebih unik untuk testing
});

// 1. Provider untuk Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

// 2. Provider untuk Use Case
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});

// 3. Provider untuk State Controller (Pengganti _isLoading)
final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
      return LoginController(ref.watch(signInUseCaseProvider));
    });

// Provider untuk SignOut UseCase
final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

class LoginController extends StateNotifier<AsyncValue<void>> {
  final SignInUseCase _signInUseCase;
  LoginController(this._signInUseCase) : super(const AsyncData(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _signInUseCase.call(email: email, password: password);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
