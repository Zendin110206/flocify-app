//lib/features/price/presentation/widgets/lapak/lapak_header.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LapakHeader extends StatelessWidget implements PreferredSizeWidget {
  const LapakHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12); // Tambahan tinggi sedikit agar proporsional

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // Status bar terang
      child: Container(
        color: Colors.transparent, // Tetap transparan sesuai permintaan
        padding: const EdgeInsets.only(
          bottom: 12,
        ), // Konsisten dengan PriceHeader
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const Text(
                  'Lapak Jual Beli',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Warna putih seperti sebelumnya
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
