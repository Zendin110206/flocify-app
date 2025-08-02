// lib/features/users/presentation/providers/user_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import 'package:proyek_flocify/features/users/data/repositories/user_repository_impl.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import 'package:proyek_flocify/features/users/domain/repositories/user_repository.dart';

// 1. Provider untuk implementasi Repository
//    Ini hanya akan dibuat sekali per aplikasi.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});

// 2. Provider untuk MENDAPATKAN data profil pengguna yang SEDANG LOGIN.
//    Ini adalah provider yang paling sering digunakan oleh UI.
//    .autoDispose akan otomatis membersihkan state saat tidak ada yang listen.
// ========================== PROVIDER BARU & UTAMA ==========================
/// Provider ini menyediakan stream data UserProfile yang sedang login.
/// Gunakan `ref.watch(userProfileStreamProvider)` di UI.
/// Ini akan secara otomatis rebuild widget ketika data profil di Firestore berubah.
final userProfileStreamProvider = StreamProvider.autoDispose<UserProfile?>((
  ref,
) {
  // 1. Dapatkan UID pengguna yang sedang login dari authStateProvider.
  //    Menggunakan `watch` memastikan jika pengguna logout/login, provider ini akan dieksekusi ulang.
  final userId = ref.watch(currentUserIdProvider);

  // 2. Dapatkan instance dari UserRepository.
  final repository = ref.watch(userRepositoryProvider);

  // 3. Panggil method stream yang baru kita buat.
  return repository.getUserProfileStream(userId);
});
