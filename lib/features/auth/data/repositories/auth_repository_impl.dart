// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/exceptions/auth_exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Kita bisa menangani error spesifik di sini nanti
      print('FirebaseAuthException on SignIn, code: ${e.code}');
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    }
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      try {
        await result.user?.sendEmailVerification();
      } catch (e) {
        // Log error jika pengiriman email gagal, tapi jangan hentikan alur.
        // Pendaftaran tetap berhasil.
        print('Gagal mengirim email verifikasi: $e');
      }
      // =======================================================================

      return result.user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException on SignUp, code: ${e.code}'); // Log kodenya
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
