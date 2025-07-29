// Path: lib/features/auth/presentation/providers/auth_providers.dart (VERSI PERBAIKAN)

import 'package:firebase_auth/firebase_auth.dart'; // Pastikan ini diimpor
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

// ===================================================================
// SUMBER KEBENARAN OTENTIKASI (Authentication Truth Source)
// ===================================================================

/// Provider ini adalah SATU-SATUNYA yang langsung berkomunikasi
/// dengan Firebase Auth untuk status login. Semua provider lain
/// yang butuh tahu status login HARUS bergantung pada ini.
final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Provider untuk mendapatkan UID pengguna yang SEDANG LOGIN.
/// Ini akan gagal (throw error) jika dipanggil saat tidak ada pengguna yang login.
/// Ini adalah perilaku yang DIINGINKAN, karena memaksa kita untuk hanya
/// memanggilnya dari tempat yang aman (di belakang layar login).
final currentUserIdProvider = Provider<String>((ref) {
  // .watch() akan membuat provider ini otomatis update jika status login berubah.
  final user = ref.watch(authStateProvider).value;

  // Jika ada user, kembalikan UID-nya.
  if (user != null) {
    return user.uid;
  }
  // Jika user null, lempar error. Ini akan membantu kita menemukan bug
  // di mana kita mencoba mengakses data user padahal sudah logout.
  throw Exception('User is not logged in, cannot get user ID.');
});

// ===================================================================
// LAPISAN REPOSITORY & USE CASE (Tidak ada perubahan)
// ===================================================================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

// ===================================================================
// CONTROLLER UNTUK INTERAKSI UI (Login & Signup)
// ===================================================================

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, AsyncValue<void>>((ref) {
      // Sekarang kita inject ref agar controller bisa memanggil use case lain jika perlu.
      return LoginController(ref);
    });

class LoginController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  LoginController(this._ref) : super(const AsyncData(null));

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      // Baca use case di dalam method, bukan di constructor.
      final signInUseCase = _ref.read(signInUseCaseProvider);
      final user = await signInUseCase.call(email: email, password: password);

      if (user == null) {
        throw Exception('Email atau kata sandi salah.');
      }

      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

final signupControllerProvider =
    StateNotifierProvider.autoDispose<SignupController, AsyncValue<void>>((
      ref,
    ) {
      return SignupController(ref);
    });

class SignupController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  SignupController(this._ref) : super(const AsyncData(null));

  Future<User?> signUpAndReturnUser(String email, String password) async {
    state = const AsyncLoading();
    try {
      final signUpUseCase = _ref.read(signUpUseCaseProvider);
      // Panggil use case
      final user = await signUpUseCase.call(email: email, password: password);
      // Set state berhasil
      state = const AsyncData(null);
      // Kembalikan objek User
      return user;
    } catch (e, stackTrace) {
      // Tambahkan stackTrace
      state = AsyncError(e, stackTrace);
      // Kembalikan null jika gagal
      return null;
    }
  }

  // Tambahkan method ini untuk menangani error dari luar
  void setError(Object e, StackTrace s) {
    state = AsyncError(e, s);
  }
}
