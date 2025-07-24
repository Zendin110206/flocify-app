// Path: lib/features/flora/domain/models/detection_history.dart

import 'package:equatable/equatable.dart';

// Menggunakan Equatable adalah best practice untuk membandingkan objek model.
// Ini membantu Riverpod untuk tahu kapan state benar-benar berubah.
class DetectionHistory extends Equatable {
  final String id;
  final String fishType;
  final String healthStatus;
  final int confidence;
  final DateTime date;
  final String imageUrl;
  final List<String> symptoms;
  final List<String> recommendations;

  const DetectionHistory({
    required this.id,
    required this.fishType,
    required this.healthStatus,
    required this.confidence,
    required this.date,
    required this.imageUrl,
    required this.symptoms,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [id, fishType, healthStatus, confidence, date];
}
