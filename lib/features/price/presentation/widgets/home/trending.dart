// lib/widgets/home/trending_hashtags.dart
import 'package:flutter/material.dart';

class TrendingHashtagsSection extends StatelessWidget {
  const TrendingHashtagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending Topik',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF292D32),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE74C3C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('🔥', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Topik Hangat Hari Ini',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF292D32),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  HashtagChip(
                    hashtag: '#BudidayaLele',
                    count: '2.3k posts',
                    color: Color(0xFF2ECC71),
                    isHot: true,
                  ),
                  HashtagChip(
                    hashtag: '#UdangVaname',
                    count: '1.8k posts',
                    color: Color(0xFFE67E22),
                  ),
                  HashtagChip(
                    hashtag: '#HargaIkan',
                    count: '1.5k posts',
                    color: Color(0xFF3498DB),
                  ),
                  HashtagChip(
                    hashtag: '#PakanIkan',
                    count: '980 posts',
                    color: Color(0xFF9B59B6),
                  ),
                  HashtagChip(
                    hashtag: '#TipsGurame',
                    count: '756 posts',
                    color: Color(0xFFF39C12),
                  ),
                  HashtagChip(
                    hashtag: '#PenyakitIkan',
                    count: '634 posts',
                    color: Color(0xFFE74C3C),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HashtagChip extends StatelessWidget {
  final String hashtag;
  final String count;
  final Color color;
  final bool isHot;

  const HashtagChip({
    super.key,
    required this.hashtag,
    required this.count,
    required this.color,
    this.isHot = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHot) ...[
              const Text('🔥', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
            ],
            Text(
              hashtag,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              count,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}