// Path: lib/features/flora/presentation/screens/analysis_result_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proyek_flocify/features/flora/domain/models/analysis_result.dart';
import 'package:proyek_flocify/features/flora/presentation/screens/detection_detail_screen.dart';
import 'camera_screen.dart';
import 'chat_screen.dart';

class AnalysisResultScreen extends StatelessWidget {
  final AnalysisResult result;
  final List<File> sourceImages;

  const AnalysisResultScreen({
    super.key,
    required this.result,
    required this.sourceImages,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHealthy = result.healthStatus == 'Sehat';
    final Color statusColor = isHealthy ? Colors.green : Colors.orange;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isHealthy
                    ? Icons.check_circle_outline_rounded
                    : Icons.warning_amber_rounded,
                color: statusColor,
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                'Analisis Selesai!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${result.fishType} terdeteksi ${result.healthStatus.toLowerCase()} dengan keyakinan ${(result.confidence * 100).toStringAsFixed(0)}%.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7F8C8D),
                  height: 1.5,
                ),
              ),
              if (result.symptoms.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Gejala: ${result.symptoms.join(', ')}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const CameraScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF638ECB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Scan Lagi'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              analysisResult: result,
                              images: sourceImages,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF638ECB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tanya AI'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Lihat Detail Lengkap'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetectionDetailScreen(detectionId: result.id),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: const Color(0xFF395886),
                    side: BorderSide(
                      color: const Color(0xFF395886).withAlpha((0.5*255).round()),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
