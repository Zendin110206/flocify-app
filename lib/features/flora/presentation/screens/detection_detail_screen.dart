// Path: lib/features/flora/presentation/screens/detection_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/core/widgets/smart_image.dart';
import 'package:proyek_flocify/features/flora/domain/models/analysis_result.dart';
import 'package:proyek_flocify/features/flora/presentation/screens/camera_screen.dart';
import 'package:proyek_flocify/features/flora/presentation/screens/chat_screen.dart';
import '../providers/flora_providers.dart';

class DetectionDetailScreen extends ConsumerWidget {
  final String detectionId;

  const DetectionDetailScreen({super.key, required this.detectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Panggil provider dengan .family, memberikan ID yang dibutuhkan
    final detailAsync = ref.watch(detectionDetailProvider(detectionId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF638ECB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Deteksi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _shareDetection(context),
          ),
        ],
      ),
      // Gunakan .when() untuk menangani semua state
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (detection) {
          // 'detection' adalah objek DetectionHistory tunggal dari provider.
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: SmartImage(
                    imageUrl: detection.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                // Detection Info Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detection.fishType,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: detection.healthStatus == 'Sehat'
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                detection.healthStatus,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: detection.healthStatus == 'Sehat'
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Tingkat Keyakinan',
                          value: '${detection.confidence}%',
                        ),
                        _DetailRow(
                          label: 'Tanggal Deteksi',
                          value: _formatDateTime(detection.date),
                        ),
                        _DetailRow(label: 'ID Deteksi', value: detection.id),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Symptoms Card (hanya tampil jika ada gejala)
                if (detection.symptoms.isNotEmpty) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gejala yang Terdeteksi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...detection.symptoms.map(
                            (symptom) => _ListItem(
                              icon: Icons.warning_amber_rounded,
                              text: symptom,
                              iconColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Recommendations Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rekomendasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...detection.recommendations.map(
                          (recommendation) => _ListItem(
                            icon: Icons.check_circle_outline,
                            text: recommendation,
                            iconColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =========================================================
                // --- PERUBAHAN UTAMA ADA DI BLOK INI ---
                // =========================================================
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigasi ke CameraScreen untuk memulai scan baru
                          Navigator.of(context).push(
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
                        child: const Text('Scan Ulang'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Adaptasi data dari DetectionHistory ke AnalysisResult
                          final analysisResultFromHistory =
                              AnalysisResult.fromHistory(detection);

                          // Navigasi ke ChatScreen dengan konteks dari riwayat
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                analysisResult: analysisResultFromHistory,
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
                        child: const Text('Konsultasi FLORA'),
                      ),
                    ),
                  ],
                ),
                // =========================================================
                // --- AKHIR DARI PERUBAHAN ---
                // =========================================================
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _shareDetection(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur berbagi akan segera tersedia'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _ListItem({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
