// Path: lib/features/flora/presentation/widgets/camera_top_app_bar.dart
import 'package:flutter/material.dart';

class CameraTopAppBar extends StatelessWidget {
  final VoidCallback onClose;

  const CameraTopAppBar({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 24,
          right: 24,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withAlpha(204), // 0.8 alpha
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(102), // 0.4 alpha
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withAlpha(51),
                  ), // 0.2 alpha
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                const Text(
                  'Fish Disease Detection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'AI Powered Analysis',
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF).withAlpha(179), // 0.7 alpha
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(width: 44), // Placeholder agar judul tetap di tengah
          ],
        ),
      ),
    );
  }
}
