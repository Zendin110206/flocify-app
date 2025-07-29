import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_providers.dart';

import 'package:proyek_flocify/features/forum/presentation/screens/forum_screen.dart';
import 'package:proyek_flocify/features/flora/presentation/screens/flora_home_screen.dart';
import 'package:proyek_flocify/features/price/presentation/screens/home_screen.dart';

class CategorySection extends ConsumerWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedCategoryProvider);

    final categories = [
      {'title': 'Harga', 'icon': Icons.attach_money},
      {'title': 'Forum', 'icon': Icons.chat_bubble_outline},
      {'title': 'FLORA', 'icon': Icons.visibility_outlined},
      {'title': 'Perks', 'icon': Icons.trending_up},
      {'title': 'Device', 'icon': Icons.devices},
    ];

    return Container(
      margin: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 85,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              clipBehavior: Clip.none,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryCard(
                  category['title'] as String,
                  category['icon'] as IconData,
                  index,
                  selectedIndex == index,
                  // =========================================================
                  // --- PERUBAHAN UTAMA ADA DI SINI ---
                  () {
                    if (category['title'] == 'FLORA') {
                      // Jika ya, navigasi ke FloraHomeScreen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FloraHomeScreen(),
                        ),
                      );
                    } else if (category['title'] == 'Forum') {
                      // Jika ya, navigasi ke ForumScreen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForumScreen(),
                        ),
                      );
                    } else if (category['title'] == 'Harga') {
                      // <-- TAMBAHKAN KONDISI INI
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      // Jika bukan, lakukan aksi seperti biasa
                      ref.read(selectedCategoryProvider.notifier).state = index;
                    }
                  },
                  // --- AKHIR DARI PERUBAHAN ---
                  // =========================================================
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    int index,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF395886) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.15 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: isActive
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8AAEE0), Color(0xFF395886)],
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF2F3F56),
              size: 32,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF2F3F56),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
