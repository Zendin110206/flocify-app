// lib/features/users/domain/repositories/user_repository.dart

import '../models/user_profile.dart'; // <-- Pastikan ini mengimpor model BARU

abstract class UserRepository {
  /// Menyimpan atau memperbarui data profil pengguna di database.
  /// Menggunakan [uid] sebagai ID dokumen unik.
  Future<void> saveUserProfile(UserProfile userProfile);

  /// Mengambil data profil pengguna dari database berdasarkan [uid].
  /// Mengembalikan `null` jika pengguna tidak ditemukan.
  Future<UserProfile?> getUserProfile(String uid);

  /// Mengecek apakah profil untuk [uid] tertentu sudah ada.
  /// Berguna untuk alur onboarding.
  Future<bool> doesUserProfileExist(String uid);

  /// Mendapatkan stream data profil pengguna secara real-time berdasarkan [uid].
  /// Akan otomatis mengirim data baru setiap kali ada perubahan di Firestore.
  Stream<UserProfile?> getUserProfileStream(String uid);
}
