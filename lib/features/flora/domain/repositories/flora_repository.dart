// KODE FINAL & LENGKAP UNTUK KONTRAK

import '../models/detection_history.dart';
import '../models/detection_guide.dart';
import '../models/analysis_result.dart';
import '../models/chat_message.dart';
import 'dart:io';

/// Kontrak abstrak untuk semua operasi data terkait fitur FLORA.
/// Ini adalah "Single Source of Truth" untuk fungsionalitas fitur ini.
abstract class FloraRepository {
  /// Mengambil daftar semua riwayat deteksi.
  Future<List<DetectionHistory>> getDetectionHistory();

  /// Mengambil detail dari satu riwayat deteksi berdasarkan ID.
  Future<DetectionHistory> getDetectionDetail(String id);

  /// Mengambil panduan-panduan untuk pengambilan gambar.
  Future<List<DetectionGuide>> getDetectionGuides();

  /// Mengirim pesan baru ke bot dan mendapatkan balasan.
  Future<ChatMessage> sendMessage({
    required String text,
    List<File>? images,
    String? analysisContextId,
  });

  /// Mengambil riwayat percakapan awal.
  Future<List<ChatMessage>> getInitialChat();

  /// Memulai proses analisis pada sekumpulan gambar.
  Future<AnalysisResult> analyzeImages(List<File> images);

  /// Menyimpan hasil analisis ke dalam riwayat.
  Future<void> saveDetectionToHistory(AnalysisResult result);
}
