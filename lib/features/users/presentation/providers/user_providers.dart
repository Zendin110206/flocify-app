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
final userProfileProvider = FutureProvider.autoDispose<UserProfile?>((ref) {
  // Provider ini bergantung pada UID pengguna yang sedang login.
  // Jika user logout, provider ini akan otomatis re-evaluate dan gagal (ini bagus!).
  try {
    final uid = ref.watch(currentUserIdProvider);
    // Panggil repository untuk mendapatkan data.
    return ref.watch(userRepositoryProvider).getUserProfile(uid);
  } catch (e) {
    // Ini terjadi jika tidak ada user yang login (currentUserIdProvider throw error).
    // Kembalikan null karena memang tidak ada profil untuk ditampilkan.
    return null;
  }
});
