// Path: lib/features/flora/presentation/widgets/history_card.dart

import 'package:flutter/material.dart';
import 'package:proyek_flocify/core/widgets/smart_image.dart';
import 'package:proyek_flocify/features/flora/domain/models/detection_history.dart';

class HistoryCard extends StatelessWidget {
  final DetectionHistory detection;
  final VoidCallback onTap;

  const HistoryCard({super.key, required this.detection, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.black.withAlpha((0.1 * 255).round()),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SmartImage(
                  imageUrl: detection.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,

                  // Error handling jika gambar tidak ditemukan
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detection.fishType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: detection.healthStatus == 'Sehat'
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            detection.healthStatus,
                            style: TextStyle(
                              fontSize: 10,
                              color: detection.healthStatus == 'Sehat'
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${detection.confidence}% keyakinan',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(detection.date),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF7F8C8D)),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi format tanggal bisa kita letakkan di sini juga
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays >= 1) return '${difference.inDays} hari yang lalu';
    if (difference.inHours >= 1) return '${difference.inHours} jam yang lalu';
    return '${difference.inMinutes} menit yang lalu';
  }
}
