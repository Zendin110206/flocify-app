// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

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
      print('FirebaseAuthException: ${e.message}');
      return null;
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
      // TODO: Kirim email verifikasi setelah berhasil mendaftar
      // result.user?.sendEmailVerification();
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Tangani error spesifik, misal: email sudah digunakan
      print('FirebaseAuthException on SignUp: ${e.message}');
      // Melempar kembali error agar bisa ditangkap oleh UI
      throw Exception(e.message ?? 'Terjadi kesalahan saat mendaftar');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
