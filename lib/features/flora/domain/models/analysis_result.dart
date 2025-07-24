// Path: lib/features/flora/domain/models/analysis_result.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/detection_history.dart';

part 'analysis_result.freezed.dart';
part 'analysis_result.g.dart';


@freezed
class AnalysisResult with _$AnalysisResult {
  const factory AnalysisResult({
    required String id,
    required String fishType,
    required String healthStatus,
    // Menggunakan double (misal: 0.85) lebih standar untuk confidence score dari sebuah model AI
    required double confidence,
    required List<String> symptoms,
    required List<String> recommendations,
    // Menyertakan imageUrl di sini akan mempermudah saat menampilkannya di halaman hasil
    required String imageUrl,
  }) = _AnalysisResult;

  /// Factory constructor untuk membuat instance AnalysisResult dari JSON.
  /// Ini adalah kunci utama untuk "kesiapan backend". Saat API nyata sudah ada,
  /// kita tidak perlu mengubah apa pun di sisi UI untuk parsing data.
  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);

  /// Factory constructor untuk membuat instance AnalysisResult dari DetectionHistory.
  factory AnalysisResult.fromHistory(DetectionHistory history) {
    return AnalysisResult(
      id: history.id,
      fishType: history.fishType,
      healthStatus: history.healthStatus,
      confidence:
          history.confidence / 100.0, // Konversi int (85) ke double (0.85)
      symptoms: history.symptoms,
      recommendations: history.recommendations,
      imageUrl: history.imageUrl,
    );
  }
}
