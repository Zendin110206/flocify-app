// Path: lib/features/flora/presentation/widgets/example_dialog_content.dart

import 'package:flutter/material.dart';
import 'package:proyek_flocify/features/flora/domain/models/detection_guide.dart';

class ExampleDialogContent extends StatelessWidget {
  final DetectionGuide guide;

  const ExampleDialogContent({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Dialog
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border.all(color: guide.color.withAlpha(77)), // 0.3 alpha
            ),
            child: Row(
              children: [
                Icon(guide.icon, color: guide.color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide.title,
                        style: TextStyle(
                          color: guide.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Contoh foto yang benar',
                        style: TextStyle(
                          color: const Color(
                            0xFFFFFFFF,
                          ).withAlpha(179), // 0.7 alpha
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: const Color(0xFFFFFFFF).withAlpha(179), // 0.7 alpha
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Gambar Contoh dari Aset dengan Chip Kualitas
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              border: Border.symmetric(
                horizontal: BorderSide(color: guide.color.withAlpha(77)),
              ), // 0.3 alpha
            ),
            child: ClipRRect(
              child: Stack(
                children: [
                  // Layer 1: Gambar
                  Positioned.fill(
                    child: Image.asset(
                      guide.exampleImagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.withAlpha(150),
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gambar tidak ditemukan',
                                style: TextStyle(
                                  color: Colors.red.withAlpha(150),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Layer 2: Chip "Kualitas Baik"
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Kualitas Baik',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bagian Tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              border: Border.all(color: guide.color.withAlpha(77)), // 0.3 alpha
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tips untuk ${guide.title}:',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...guide.tips.map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: const Color(0xFFFFFFFF).withAlpha(179),
                          ), // 0.7 alpha
                        ),
                        Expanded(
                          child: Text(
                            tip,
                            style: TextStyle(
                              color: const Color(
                                0xFFFFFFFF,
                              ).withAlpha(179), // 0.7 alpha
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
