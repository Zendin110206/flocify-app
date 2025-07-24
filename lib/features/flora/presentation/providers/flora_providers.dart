// Path: lib/features/flora/presentation/providers/flora_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/flora/data/repositories/fake_flora_repository_impl.dart';
import 'package:proyek_flocify/features/flora/domain/models/detection_history.dart';
import 'package:proyek_flocify/features/flora/domain/repositories/flora_repository.dart';

import 'camera_screen_controller.dart';
import 'camera_screen_state.dart';
import 'chat_screen_controller.dart';
import 'chat_screen_state.dart';

// =========================================================================
// PROVIDER UNTUK LAPISAN DATA
// =========================================================================

/// Provider ini bertanggung jawab untuk menyediakan implementasi dari [FloraRepository].
/// Ini adalah inti dari Dependency Injection. UI tidak perlu tahu sumber datanya dari mana.
final floraRepositoryProvider = Provider<FloraRepository>((ref) {
  // Saat ini kita menggunakan data palsu.
  return FakeFloraRepository();

  // Nanti saat sudah ada backend, kita tinggal ganti baris di atas dengan:
  // return FirebaseFloraRepository();
});

// =========================================================================
// PROVIDER UNTUK DATA SCREEN
// =========================================================================

/// [FutureProvider] untuk mengambil daftar riwayat deteksi secara asinkron.
/// Provider ini akan digunakan oleh HistoryScreen untuk menampilkan semua data.
/// `.autoDispose` digunakan agar state provider dibersihkan saat tidak lagi digunakan,
/// ini baik untuk manajemen memori.
final detectionHistoryProvider =
    FutureProvider.autoDispose<List<DetectionHistory>>((ref) {
      // Membaca (watch) repository dari provider di atas.
      final floraRepository = ref.watch(floraRepositoryProvider);

      // Memanggil method untuk mendapatkan data dan mengembalikannya.
      // Riverpod akan secara otomatis menangani state loading, data, dan error.
      return floraRepository.getDetectionHistory();
    });

/// [FutureProvider.family] untuk mengambil detail dari SATU riwayat deteksi.
/// Kita menggunakan `.family` karena kita perlu memberikan parameter (yaitu `id` deteksi).
/// Ini akan digunakan oleh DetectionDetailScreen.
final detectionDetailProvider = FutureProvider.autoDispose
    .family<DetectionHistory, String>((ref, id) {
      final floraRepository = ref.watch(floraRepositoryProvider);
      return floraRepository.getDetectionDetail(id);
    });

/// Provider untuk mengelola state dan logika dari CameraScreen.
/// Menggunakan StateNotifierProvider karena state-nya kompleks dan punya logika.

final cameraScreenControllerProvider =
    StateNotifierProvider.autoDispose<
      CameraScreenController,
      CameraScreenState
    >((ref) {
      final controller = CameraScreenController(ref);

      // .onDispose akan dipanggil secara otomatis oleh Riverpod
      // saat provider ini tidak lagi didengarkan (misal: saat user keluar dari layar)
      ref.onDispose(() {
        // Kita panggil method pembersih yang sudah kita buat
        controller.resetState();
      });

      return controller;
    });

final chatScreenControllerProvider =
    StateNotifierProvider.autoDispose<ChatScreenController, ChatScreenState>((
      ref,
    ) {
      return ChatScreenController(ref);
    });
