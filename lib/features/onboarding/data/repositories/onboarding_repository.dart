// Path: lib/features/onboarding/data/repositories/onboarding_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider untuk instance SharedPreferences, agar bisa diakses di mana saja.
// FutureProvider digunakan karena inisialisasi SharedPreferences bersifat async.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

// Provider untuk repository kita.
// Ini akan menjadi satu-satunya cara kita berinteraksi dengan SharedPreferences.
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  // .watch() akan membuat provider ini rebuild saat FutureProvider selesai.
  final sharedPrefs = ref.watch(sharedPreferencesProvider).asData?.value;

  // Jika SharedPreferences belum siap (saat aplikasi baru start),
  // kita lempar exception agar jelas ada yang salah jika dipanggil terlalu dini.
  if (sharedPrefs == null) {
    throw Exception("SharedPreferences not initialized yet");
  }

  return OnboardingRepository(sharedPrefs);
});

/// Repository ini bertanggung jawab untuk semua operasi terkait
/// state onboarding yang perlu disimpan secara permanen di perangkat.
class OnboardingRepository {
  final SharedPreferences _prefs;
  OnboardingRepository(this._prefs);

  // Kunci yang aman untuk menyimpan data di SharedPreferences.
  static const _keyOnboardingComplete = 'onboardingComplete';

  /// Memeriksa apakah pengguna sudah menyelesaikan onboarding.
  /// Mengembalikan `false` jika kunci tidak ditemukan.
  bool isOnboardingComplete() {
    return _prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  /// Menandai bahwa pengguna telah menyelesaikan onboarding.
  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(_keyOnboardingComplete, true);
  }
}
