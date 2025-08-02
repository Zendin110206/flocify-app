// lib/features/auth/domain/exceptions/auth_exceptions.dart

/// Kelas dasar untuk semua kegagalan yang berkaitan dengan pendaftaran.
/// Mengimplementasikan `Exception` adalah praktik standar di Dart.
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// Pesan error yang ramah pengguna dan siap ditampilkan di UI.
  final String message;

  /// Constructor dasar.
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'Terjadi kesalahan yang tidak diketahui saat mendaftar.',
  ]);

  /// Factory constructor untuk membuat exception yang sesuai berdasarkan
  /// kode error yang diberikan oleh Firebase Auth.
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Format email tidak valid. Mohon periksa kembali.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'Akun ini telah dinonaktifkan. Silakan hubungi dukungan.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'Alamat email ini sudah terdaftar. Silakan masuk atau gunakan email lain.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operasi ini tidak diizinkan. Silakan hubungi dukungan.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Kata sandi terlalu lemah. Gunakan kombinasi yang lebih kuat.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  String toString() => message;
}

// ========================== KELAS EXCEPTION BARU ==========================
/// Kelas untuk semua kegagalan yang berkaitan dengan proses login.
class LogInWithEmailAndPasswordFailure implements Exception {
  /// Pesan error yang ramah pengguna.
  final String message;

  const LogInWithEmailAndPasswordFailure([
    this.message = 'Terjadi kesalahan yang tidak diketahui saat masuk.',
  ]);

  /// Factory constructor untuk menerjemahkan kode error Firebase.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Format email tidak valid. Mohon periksa kembali.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'Akun ini telah dinonaktifkan.',
        );
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential': // Kode error baru dari Firebase
        return const LogInWithEmailAndPasswordFailure(
          'Email atau kata sandi salah. Mohon periksa kembali.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  String toString() => message;
}
