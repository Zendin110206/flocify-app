// lib/widgets/lapak/filter_pills_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LapakFilterPillsBar extends StatelessWidget {
  final String sizeLabel;
  final VoidCallback onTapSize;
  final VoidCallback onTapCariLokasi;

  /// Tampilkan tombol reset hanya ketika filter tidak default.
  final bool showReset;
  final VoidCallback? onReset;

  const LapakFilterPillsBar({
    super.key,
    required this.sizeLabel,
    required this.onTapSize,
    required this.onTapCariLokasi,
    this.showReset = false,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF638ECB);
    final Color inactiveText = Colors.grey[600]!;
    final BorderRadius radius = BorderRadius.circular(20);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Pill Size (aktif)
            _PrimaryPill(
              radius: radius,
              color: primary,
              icon: Icons.filter_list,
              label: sizeLabel,
              onTap: onTapSize,
            ),
            const SizedBox(width: 12),

            // Pill Cari Lokasi (outlined)
            _OutlinedPill(
              radius: radius,
              icon: Icons.location_on,
              label: 'Cari Lokasi',
              textColor: inactiveText,
              onTap: onTapCariLokasi,
            ),

            // Animated appearance for Reset
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                final offsetAnim = Tween<Offset>(
                  begin: const Offset(0.08, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ));
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: offsetAnim, child: child),
                );
              },
              child: showReset
                  ? Row(
                      key: const ValueKey('reset-visible'),
                      children: [
                        const SizedBox(width: 12),
                        _OutlinedPill(
                          radius: radius,
                          icon: Icons.refresh,
                          label: 'Reset Filter',
                          textColor: Colors.black54,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            onReset?.call();
                          },
                        ),
                      ],
                    )
                  : const SizedBox(key: ValueKey('reset-hidden')),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryPill extends StatelessWidget {
  final BorderRadius radius;
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PrimaryPill({
    required this.radius,
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedPill extends StatelessWidget {
  final BorderRadius radius;
  final IconData icon;
  final String label;
  final Color textColor;
  final VoidCallback onTap;

  const _OutlinedPill({
    required this.radius,
    required this.icon,
    required this.label,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
