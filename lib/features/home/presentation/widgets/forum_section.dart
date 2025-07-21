// lib/features/home/presentation/widgets/forum_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForumSection extends StatelessWidget {
  const ForumSection({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = ['Tips Budidaya\nLele Modern', 'Cara Mengatasi\nPenyakit Ikan', 'Strategi Pakan\nEfisien', 'Monitoring\nKualitas Air', 'Teknologi\nAquakultur'];

    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.symmetric(horizontal: 18.0), child: Text('Forum Diskusi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              clipBehavior: Clip.none,
              itemCount: topics.length,
              itemBuilder: (context, index) => _buildForumCard(topics[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumCard(String title, int index) {
    final colors = [const Color(0xFF4CAF50), const Color(0xFF2196F3), const Color(0xFF9C27B0), const Color(0xFFFF9800), const Color(0xFFE91E63)];
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withAlpha((0.1 * 255).round()), color.withAlpha(0)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha((0.2 * 255).round())),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withAlpha((0.1*255).round()), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.forum_outlined, color: color, size: 20)),
            const SizedBox(height: 12),
            Expanded(child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.3))),
          ],
        ),
      ),
    );
  }
}