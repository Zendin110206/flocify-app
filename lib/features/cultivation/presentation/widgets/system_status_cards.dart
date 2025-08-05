// lib/features/cultivation/presentation/widgets/system_status_cards.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/cultivation/presentation/providers/cultivation_providers.dart';
import '../screens/detail/monitoring/monitoring_detail_screen.dart';
// import '../screens/detail/controlling/controlling_detail_screen.dart';

class SystemStatusCards extends ConsumerWidget {
  const SystemStatusCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Baca state di sini, di level tertinggi yang membutuhkannya.
    final activePondId = ref.watch(activePondIdProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _SystemCard(
              title: 'Monitoring',
              iconData: Icons.monitor,
              activePartsCount: 4,
              onTap: () {
                // Jangan lakukan navigasi jika tidak ada kolam yang dipilih
                if (activePondId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih sebuah kolam terlebih dahulu.'),
                    ),
                  );
                  return;
                }
                // Lakukan navigasi dan kirim data pondId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MonitoringDetailScreen(pondId: activePondId),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _SystemCard(
              title: 'Controlling',
              iconData: Icons.auto_mode,
              activePartsCount: 4,
              onTap: () {
                if (activePondId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih sebuah kolam terlebih dahulu.'),
                    ),
                  );
                  return;
                }
                // TODO: Arahkan ke ControllingDetailScreen nanti
                debugPrint('Controlling Tapped for Pond ID: $activePondId');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  const _SystemCard({
    required this.title,
    required this.iconData,
    required this.activePartsCount,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final int activePartsCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final size = math.min(constraints.maxWidth, 200.0);
        return InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFB1C9EF),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.12 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IconCircle(
                  diameter: size * 0.55,
                  icon: iconData,
                  label: title == 'Monitoring'
                      ? 'Smart\nMonitor'
                      : 'Auto\nControl',
                ),
                const SizedBox(height: 12),
                _CardLabel(title: title, activePartsCount: activePartsCount),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.diameter,
    required this.icon,
    required this.label,
  });

  final double diameter;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: diameter * 0.7,
          height: diameter * 0.7,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: diameter * 0.24, color: Colors.black87),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: diameter * 0.11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({required this.title, required this.activePartsCount});

  final String title;
  final int activePartsCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bool isActive = true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF292D32),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF34C759)
                      : const Color(0xFFFF3B30),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$activePartsCount active parts',
                style:
                    theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ) ??
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
