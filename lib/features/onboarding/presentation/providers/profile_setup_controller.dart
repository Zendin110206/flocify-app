// lib/features/onboarding/presentation/providers/profile_setup_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import 'package:proyek_flocify/features/users/presentation/providers/user_providers.dart';

// Provider untuk controller kita.
// .autoDispose memastikan controller akan dihancurkan saat tidak lagi digunakan.
final profileSetupControllerProvider =
    StateNotifierProvider.autoDispose<ProfileSetupController, AsyncValue<void>>(
      (ref) {
        return ProfileSetupController(ref);
      },
    );

class ProfileSetupController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  // Controller dimulai dengan state 'data' (tidak ada proses yang berjalan).
  ProfileSetupController(this._ref) : super(const AsyncData(null));

  /// Fungsi utama untuk menyimpan profil pengguna.
  /// Menerima objek UserProfile yang sudah lengkap dari UI.
  Future<bool> saveProfile(UserProfile profile) async {
    // Set state ke loading untuk menampilkan indicator di UI.
    state = const AsyncLoading();
    try {
      // Baca UserRepository dari provider.
      final repository = _ref.read(userRepositoryProvider);

      // Panggil method untuk menyimpan data.
      await repository.saveUserProfile(profile);

      // Jika berhasil, set state kembali ke data (sukses).
      state = const AsyncData(null);

      // Kembalikan true untuk menandakan keberhasilan ke UI.
      return true;
    } catch (e, stackTrace) {
      // Jika gagal, set state ke error.
      state = AsyncError(e, stackTrace);

      // Kembalikan false untuk menandakan kegagalan ke UI.
      return false;
    }
  }
}
