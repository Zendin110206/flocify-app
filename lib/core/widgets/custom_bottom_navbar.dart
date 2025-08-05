// lib/widgets/custom_bottom_navbar.dart

import 'package:flutter/material.dart';

/// Simple data model for nav items.
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Your five tabs, in order.
  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_filled, label: 'Beranda'),
    _NavItem(icon: Icons.trending_up_rounded, label: 'Manajemen'),
    _NavItem(icon: Icons.add_box_rounded, label: 'Input'),
    _NavItem(icon: Icons.water_drop_outlined, label: 'Budidaya'),
    _NavItem(icon: Icons.person_outline, label: 'Pengaturan'),
  ];

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 70;
    const Color bgColor = Color(0xFFD5DEEF);
    const Color activeColor = Color(0xFF395886);
    // 37,37,37 with 50% alpha → rgba(37,37,37,0.5)
    final Color inactiveColor = const Color(0xFF252525).withValues(alpha: 0.5);

    return Container(
      width: double.infinity,
      height: barHeight + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(10, 0),
            blurRadius: 4,
            color: Color(0x40000000), // 25% black
          ),
        ],
      ),
      child: Padding(
        // push content up above any bottom notch
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final bool isActive = i == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(16),
                splashColor: activeColor.withValues(alpha: 0.1),
                highlightColor: activeColor.withValues(alpha: 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? activeColor.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isActive ? 1.05 : 1.0,
                        child: Icon(
                          item.icon,
                          size: 24,
                          color: isActive ? activeColor : inactiveColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isActive ? 12 : 11,
                        fontWeight: FontWeight.w400,
                        color: isActive ? activeColor : inactiveColor,
                        height: 13 / (isActive ? 12 : 11), // line-height
                      ),
                      child: Text(item.label),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 2,
                      width: isActive ? 24 : 0,
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
