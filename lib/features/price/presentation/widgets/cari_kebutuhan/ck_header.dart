// lib/widgets/cari_kebutuhan/ck_header.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ck_colors.dart';

class CKHeader extends StatelessWidget implements PreferredSizeWidget {
  const CKHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: Colors.transparent, // latar diambil dari Scaffold
        padding: const EdgeInsets.only(bottom: 12),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.canPop(context)) Navigator.of(context).pop();
                  },
                ),
                const Text(
                  'Cari Kebutuhan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CKColors.white,
                  ),
                ),
                const Spacer(),
                // tombol notifikasi (ikon saja – sheet dibuat terpisah)
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // akan dipanggil dari screen via GlobalKey? biar simpel biarkan screen yang menangani
                    Navigator.of(context).maybePop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
