// E:\flutter_projects\buat_coba_coba_tuh_disini\coba_coba_aja\lib\widgets\price\quick_access_section.dart

import 'package:flutter/material.dart';
import 'package:proyek_flocify/features/price/presentation/screens/lapak_screen.dart';
import 'package:proyek_flocify/features/price/presentation/screens/cari_kebutuhan_screen.dart';

/// Widget untuk menampilkan tombol akses cepat seperti 'Jual Panen'.
/// Diambil dari referensi File 1 ya btw ( ini buat catatanku pribadi ).

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Pakai column buat nampung judul dan baris tombol
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul untuk seksi ini
        const Text(
          'Akses Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF292D32),
          ),
        ),

        const SizedBox(height: 12),

        //Baris tombol tombol aksi
        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                context: context,
                icon: Icons.sell_outlined,
                label: 'Jual / Beli Panen',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LapakScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickAction(
                context: context,
                icon: Icons.add_shopping_cart,
                label: 'Cari Kebutuhan',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CariKebutuhanScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Method privat untuk membangun setiap tombol di dalam seksi ini.
  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha((0.1*255).round()),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha((0.3*255).round())),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
