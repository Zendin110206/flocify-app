// Path: lib/features/flora/presentation/providers/camera_screen_state.dart

import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:proyek_flocify/features/flora/domain/models/analysis_result.dart'; // <-- IMPORT BARU
import 'package:proyek_flocify/features/flora/domain/models/detection_guide.dart';

part 'camera_screen_state.freezed.dart';

// Enum untuk merepresentasikan status halaman secara keseluruhan.
enum CameraStatus { initial, loading, ready, analyzing, success, error }

@freezed
class CameraScreenState with _$CameraScreenState {
  const factory CameraScreenState({
    // Status keseluruhan halaman untuk mengontrol UI (misal: tampilkan loading)
    @Default(CameraStatus.initial) CameraStatus status,

    // Daftar panduan yang akan ditampilkan di carousel
    @Default([]) List<DetectionGuide> guides,

    // Menyimpan gambar yang sudah diambil.
    // Key-nya adalah ID panduan (e.g., 'left_side'), Value-nya adalah file gambar.
    @Default({}) Map<String, File> capturedImages,

    // ID dari panduan yang sedang aktif/dipilih oleh pengguna.
    String? currentGuideId,

    // Untuk menyimpan pesan error jika terjadi kesalahan.
    String? errorMessage,

    // 'Slot' untuk menyimpan hasil analisis yang berhasil.
    AnalysisResult? analysisResult, // <-- PROPERTI BARU
  }) = _CameraScreenState;
}
