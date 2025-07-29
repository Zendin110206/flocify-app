// lib/widgets/home/quick_stats.dart
import 'package:flutter/material.dart';

class QuickStatsSection extends StatelessWidget {
  const QuickStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Hari Ini',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF292D32),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Transaksi',
                value: '1,234',
                subtitle: '+12% dari kemarin',
                icon: '💰',
                color: const Color(0xFF2ECC71),
                trend: TrendType.up,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Peternak Aktif',
                value: '5,678',
                subtitle: '+8% dari kemarin',
                icon: '👥',
                color: const Color(0xFF3498DB),
                trend: TrendType.up,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Rata-rata Harga',
                value: 'Rp 25k',
                subtitle: '-2% dari kemarin',
                icon: '📊',
                color: const Color(0xFFE74C3C),
                trend: TrendType.down,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Produk Terjual',
                value: '890',
                subtitle: '+15% dari kemarin',
                icon: '📦',
                color: const Color(0xFFF39C12),
                trend: TrendType.up,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required String icon,
    required Color color,
    required TrendType trend,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 16)),
              ),
              const Spacer(),
              Icon(
                trend == TrendType.up ? Icons.trending_up : Icons.trending_down,
                color: trend == TrendType.up
                    ? const Color(0xFF2ECC71)
                    : const Color(0xFFE74C3C),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF292D32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: trend == TrendType.up
                  ? const Color(0xFF2ECC71)
                  : const Color(0xFFE74C3C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

enum TrendType { up, down }
