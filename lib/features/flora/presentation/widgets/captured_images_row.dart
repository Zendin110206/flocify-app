// Path: lib/features/home/tab/flora/presentation/widgets/captured_images_row.dart

import 'package:flutter/material.dart';
import 'package:proyek_flocify/features/flora/domain/models/detection_guide.dart';

class CapturedImagesRow extends StatelessWidget {
  final List<DetectionGuide> guides;
  final Map<String, dynamic> capturedImages;
  final Function(String) onRemoveImage;

  const CapturedImagesRow({
    super.key,
    required this.guides,
    required this.capturedImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: guides.map((guide) {
          final isCaptured = capturedImages.containsKey(guide.id);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCaptured
                    ? guide.color.withAlpha(77) // 0.3 alpha
                    : const Color(0xFFFFFFFF).withAlpha(13), // 0.05 alpha
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCaptured
                      ? guide.color
                      : const Color(0xFFFFFFFF).withAlpha(51), // 0.2 alpha
                ),
              ),
              child: isCaptured
                  ? Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Icon(guide.icon, color: guide.color, size: 20),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap: () => onRemoveImage(guide.id),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1A1A1A),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Icon(
                      guide.icon,
                      color: const Color(0xFFFFFFFF).withAlpha(77), // 0.3 alpha
                      size: 20,
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
