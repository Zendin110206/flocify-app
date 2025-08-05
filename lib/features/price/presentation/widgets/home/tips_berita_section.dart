// E:\flutter_projects\buat_coba_coba_tuh_disini\coba_coba_aja\lib\widgets\price\tips_section.dart
import 'package:flutter/material.dart';

class TipsSection extends StatelessWidget {
  const TipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tips Budidaya',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF292D32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Column(
          children: [
            TipCard(
              icon: '🌡️',
              title: 'Kontrol Suhu Air',
              description:
                  'Jaga suhu air tetap stabil antara 26-30°C untuk pertumbuhan optimal ikan lele',
              category: 'Lele',
              categoryColor: Color(0xFF2ECC71),
            ),
            SizedBox(height: 12),
            TipCard(
              icon: '🦐',
              title: 'Pemberian Pakan Udang',
              description:
                  'Berikan pakan 3-4 kali sehari dengan porsi yang dapat dihabiskan dalam 2 jam',
              category: 'Udang',
              categoryColor: Color(0xFFE67E22),
            ),
            SizedBox(height: 12),
            TipCard(
              icon: '💧',
              title: 'Kualitas Air Kolam',
              description:
                  'Lakukan pengujian pH air secara berkala, pH ideal untuk ikan gurame adalah 6.5-7.5',
              category: 'Gurame',
              categoryColor: Color(0xFF3498DB),
            ),
          ],
        ),
      ],
    );
  }
}

class TipCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String category;
  final Color categoryColor;

  const TipCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.category,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categoryColor.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF292D32),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.4,
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
