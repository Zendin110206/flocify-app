// lib/widgets/cari_kebutuhan/ck_empty_state.dart
import 'package:flutter/material.dart';
import 'ck_colors.dart';

class CKEmptyState extends StatelessWidget {
  const CKEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search_off, size: 64, color: CKColors.textHint),
            SizedBox(height: 16),
            Text(
              'Tidak ada permintaan ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CKColors.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coba ubah filter atau kata kunci pencarian',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: CKColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
