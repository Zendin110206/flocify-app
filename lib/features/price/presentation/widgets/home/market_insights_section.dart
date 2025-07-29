// E:\flutter_projects\buat_coba_coba_tuh_disini\coba_coba_aja\lib\widgets\price\market_insights_section.dart

import 'package:flutter/material.dart';

/// Widget untuk menampilkan insights dan tips terkait harga pasar ikan
class MarketInsightsSection extends StatelessWidget {
  const MarketInsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Market Insights',
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
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildInsightCard(
                title: 'Analisis Harga',
                subtitle: 'Trend harga minggu ini',
                description: 'Harga lele naik 15% karena cuaca buruk',
                color: const Color(0xFF4CAF50),
                icon: Icons.trending_up,
                tag: 'TRENDING',
                tagColor: const Color(0xFF4CAF50),
              ),
              const SizedBox(width: 16),
              _buildInsightCard(
                title: 'Prediksi Pasar',
                subtitle: 'Forecast 2 minggu ke depan',
                description: 'Harga udang diprediksi stabil hingga akhir bulan',
                color: const Color(0xFF2196F3),
                icon: Icons.analytics,
                tag: 'FORECAST',
                tagColor: const Color(0xFF2196F3),
              ),
              const SizedBox(width: 16),
              _buildInsightCard(
                title: 'Supply & Demand',
                subtitle: 'Kondisi pasokan terkini',
                description: 'Permintaan nila meningkat 20% dari restoran',
                color: const Color(0xFFFF9800),
                icon: Icons.inventory,
                tag: 'HOT',
                tagColor: const Color(0xFFFF5722),
              ),
              const SizedBox(width: 16),
              _buildInsightCard(
                title: 'Tips Jual Beli',
                subtitle: 'Strategi optimal trading',
                description: 'Waktu terbaik jual ikan pagi hari jam 6-8',
                color: const Color(0xFF9C27B0),
                icon: Icons.lightbulb_outline,
                tag: 'TIPS',
                tagColor: const Color(0xFF9C27B0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Method untuk membangun setiap card insight
  Widget _buildInsightCard({
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required IconData icon,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header dengan gradient background
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                // Tag
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D29),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Action button
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Baca',
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward, color: color, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
