//lib/features/price/presentation/widgets/home/success_stories.dart

import 'package:flutter/material.dart';

class SuccessStoriesSection extends StatelessWidget {
  const SuccessStoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kisah Sukses Peternak',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF292D32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              SuccessCard(
                name: 'Pak Budi Santoso',
                location: 'Bogor, Jawa Barat',
                story:
                    'Berhasil meningkatkan omzet 300% dengan budidaya lele organik',
                income: 'Rp 15 juta/bulan',
                avatar: '👨‍🌾',
                fishType: 'Lele',
                gradientColors: [
                  Color(0xFF4CAF50),
                  Color(0xFF81C784),
                ], // Green gradient untuk lele
              ),
              SuccessCard(
                name: 'Bu Sari Dewi',
                location: 'Sukabumi, Jawa Barat',
                story:
                    'Ekspor udang vaname ke Singapura, meraup keuntungan besar',
                income: 'Rp 25 juta/bulan',
                avatar: '👩‍🌾',
                fishType: 'Udang',
                gradientColors: [
                  Color(0xFF2196F3),
                  Color(0xFF64B5F6),
                ], // Blue gradient untuk udang
              ),
              SuccessCard(
                name: 'Pak Ahmad',
                location: 'Cirebon, Jawa Barat',
                story: 'Budidaya gurame intensif dengan teknologi modern',
                income: 'Rp 12 juta/bulan',
                avatar: '👨‍💼',
                fishType: 'Gurame',
                gradientColors: [
                  Color(0xFFFF9800),
                  Color(0xFFFFB74D),
                ], // Orange gradient untuk gurame
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SuccessCard extends StatelessWidget {
  final String name;
  final String location;
  final String story;
  final String income;
  final String avatar;
  final String fishType;
  final List<Color> gradientColors;

  const SuccessCard({
    super.key,
    required this.name,
    required this.location,
    required this.story,
    required this.income,
    required this.avatar,
    required this.fishType,
    this.gradientColors = const [Color(0xFF667eea), Color(0xFF764ba2)],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withAlpha((0.25*255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.25*255).round()),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withAlpha((0.3*255).round()),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(avatar, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.white.withAlpha((0.85*255).round()),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.25*255).round()),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withAlpha((0.3*255).round()),
                    width: 1,
                  ),
                ),
                child: Text(
                  fishType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            story,
            style: TextStyle(
              color: Colors.white.withAlpha((0.9*255).round()),
              fontSize: 12,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2*255).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  income,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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
