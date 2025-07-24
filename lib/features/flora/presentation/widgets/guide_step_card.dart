// Path: lib/features/flora/presentation/widgets/guide_step_card.dart
import 'package:flutter/material.dart';
import 'package:proyek_flocify/features/flora/domain/models/detection_guide.dart';

class GuideStepCard extends StatelessWidget {
  final DetectionGuide guide;
  final bool isSelected;
  final bool isCompleted;
  final VoidCallback onTap;

  const GuideStepCard({
    super.key,
    required this.guide,
    required this.isSelected,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? guide.color.withAlpha((0.2*255).round())
              : Colors.white.withAlpha((0.05*255).round()),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? guide.color : Colors.white.withAlpha((0.1*255).round()),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  guide.icon,
                  color: isSelected
                      ? guide.color
                      : Colors.white.withAlpha((0.7*255).round()),
                  size: 24,
                ),
                if (isCompleted)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              guide.title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? guide.color : Colors.white.withAlpha((0.7*255).round()),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
