// Path: lib/features/flora/presentation/widgets/camera_bottom_panel.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:proyek_flocify/features/flora/domain/models/detection_guide.dart';
import 'package:proyek_flocify/features/flora/presentation/providers/flora_providers.dart';
import 'package:proyek_flocify/features/flora/presentation/widgets/guide_step_card.dart';
import 'package:proyek_flocify/features/flora/presentation/widgets/example_dialog_content.dart';

import 'captured_images_row.dart';

class CameraBottomPanel extends ConsumerWidget {
  final Animation<double> pulseAnimation;
  final VoidCallback onCapture;
  final VoidCallback onGalleryTap;
  final VoidCallback onStartAnalysis;
  // --- TAMBAHKAN scrollController DI CONSTRUCTOR ---
  final ScrollController scrollController;

  const CameraBottomPanel({
    super.key,
    required this.pulseAnimation,
    required this.onCapture,
    required this.onGalleryTap,
    required this.onStartAnalysis,
    required this.scrollController, // <-- Tambahkan ini
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cameraScreenControllerProvider);
    final controller = ref.read(cameraScreenControllerProvider.notifier);

    final activeGuide =
        (state.guides.isNotEmpty && state.currentGuideId != null)
        ? state.guides.firstWhere(
            (g) => g.id == state.currentGuideId,
            orElse: () => state.guides.first,
          )
        : null;

    // --- SELURUH UI DIBUNGKUS DENGAN WIDGET DEKORASI INI ---
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(51), // 0.2 alpha
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFFFFFFF).withAlpha(26),
                ), // 0.1 alpha
              ),
            ),
            // --- BAGIAN DALAM SEKARANG MENGGUNAKAN COLUMN ---
            child: Column(
              children: [
                // --- KONTEN YANG BISA DI-SCROLL MASUK KE ListView ---
                Expanded(
                  child: ListView(
                    controller:
                        scrollController, // <-- Pasang scroll controller di sini
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF).withAlpha(77),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      _ProgressIndicator(
                        totalSteps: state.guides.length,
                        completedSteps: state.capturedImages.length,
                      ),
                      const SizedBox(height: 16),
                      if (state.guides.isNotEmpty)
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            clipBehavior: Clip.none,
                            itemCount: state.guides.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final guide = state.guides[index];
                              return GuideStepCard(
                                guide: guide,
                                isSelected: state.currentGuideId == guide.id,
                                isCompleted: state.capturedImages.containsKey(
                                  guide.id,
                                ),
                                onTap: () => controller.selectGuide(guide.id),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (activeGuide != null)
                        _GuideDescription(guide: activeGuide),
                      // Spasi yang lebih kecil saat kosong
                      if (state.capturedImages.isNotEmpty)
                        Padding(
                          // Beri padding atas agar ada jarak dari deskripsi
                          padding: const EdgeInsets.only(top: 16.0),
                          child: CapturedImagesRow(
                            guides: state.guides,
                            capturedImages: state.capturedImages,
                            onRemoveImage: (guideId) =>
                                controller.removeImage(guideId),
                          ),
                        ),
                    ],
                  ),
                ),
                // --- TOMBOL AKSI UTAMA TETAP DI LUAR, AGAR SELALU TERLIHAT ---
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    24.0,
                    0, // Padding atas tidak perlu lagi
                    24.0,
                    16.0 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: _ActionButtonsRow(
                    canAnalyze: state.capturedImages.isNotEmpty,
                    onGalleryTap: onGalleryTap,
                    onCapture: onCapture,
                    onStartAnalysis: onStartAnalysis,
                    pulseAnimation: pulseAnimation,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int completedSteps;

  const _ProgressIndicator({
    required this.totalSteps,
    required this.completedSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                color: const Color(0xFFFFFFFF).withAlpha(204), // 0.8 alpha
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$completedSteps/$totalSteps',
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (totalSteps > 0)
          LinearProgressIndicator(
            value: completedSteps / totalSteps,
            backgroundColor: const Color(0xFFFFFFFF).withAlpha(26), // 0.1 alpha
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
      ],
    );
  }
}

class _GuideDescription extends StatelessWidget {
  final DetectionGuide guide;
  const _GuideDescription({required this.guide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          guide.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFFFFFFF).withAlpha(179), // 0.7 alpha
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showExampleDialog(context, guide),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: guide.color.withAlpha(26), // 0.1 alpha
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: guide.color.withAlpha(77)), // 0.3 alpha
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility_outlined, color: guide.color, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Lihat Contoh',
                  style: TextStyle(
                    color: guide.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showExampleDialog(BuildContext context, DetectionGuide guide) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(204), // 0.8 alpha
      builder: (context) => ExampleDialogContent(guide: guide),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final bool canAnalyze;
  final VoidCallback onGalleryTap;
  final VoidCallback onCapture;
  final VoidCallback onStartAnalysis;
  final Animation<double> pulseAnimation;

  const _ActionButtonsRow({
    required this.canAnalyze,
    required this.onGalleryTap,
    required this.onCapture,
    required this.onStartAnalysis,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActionButton(
          icon: Icons.photo_library_outlined,
          label: 'Gallery',
          onTap: onGalleryTap,
        ),
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: pulseAnimation.value,
                  child: GestureDetector(
                    onTap: onCapture,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFFFFFF,
                            ).withAlpha(77), // 0.3 alpha
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF0F0F0F),
                        size: 32,
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: -20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(179), // 0.7 alpha
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Auto Next',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: canAnalyze
              ? _ActionButton(
                  key: const ValueKey('analyze_on'),
                  icon: Icons.analytics_outlined,
                  label: 'Analyze',
                  onTap: onStartAnalysis,
                  color: const Color(0xFF6366F1),
                )
              : _ActionButton(
                  key: const ValueKey('analyze_off'),
                  icon: Icons.analytics_outlined,
                  label: 'Analyze',
                  onTap: () {},
                  color: const Color(0xFFFFFFFF).withAlpha(26),
                ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color ?? const Color(0xFFFFFFFF).withAlpha(26),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFFFFF).withAlpha(26)),
            ),
            child: Icon(
              icon,
              color:
                  color != null &&
                      color != const Color(0xFFFFFFFF).withAlpha(26)
                  ? Colors.white
                  : Colors.white70,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFFFFFFFF).withAlpha(179),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
