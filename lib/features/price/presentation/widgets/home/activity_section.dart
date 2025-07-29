// E:\flutter_projects\buat_coba_coba_tuh_disini\coba_coba_aja\lib\widgets\price\activity_section.dart

import 'package:flutter/material.dart';

/// Widget untuk menampilkan daftar aktivitas terbaru.
/// Diambil dari referensi File 1.
class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActivityItem(
            icon: Icons.trending_up,
            title: 'Harga lele naik 2.8% hari ini',
            time: '2 jam lalu',
          ),
          const Divider(),
          _buildActivityItem(
            icon: Icons.shopping_cart,
            title: 'Permintaan baru: Udang 2 ton',
            time: '4 jam lalu',
          ),
          const Divider(),
          _buildActivityItem(
            icon: Icons.sell,
            title: 'Panen Anda diminati 3 pembeli',
            time: '6 jam lalu',
          ),
        ],
      ),
    );
  }

  /// Method privat untuk membangun setiap baris item aktivitas.
  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF638ECB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF638ECB), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
