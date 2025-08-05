//lib/features/price/presentation/widgets/cari_kebutuhan/ck_notifications_sheet.dart
import 'package:flutter/material.dart';
import 'ck_colors.dart';

class CKNotificationsSheet {
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: CKColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CKColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _item(
              icon: Icons.new_releases,
              title: 'Permintaan Baru',
              message: '3 permintaan baru sesuai kriteria Anda',
              time: '5 menit lalu',
              isNew: true,
            ),
            _item(
              icon: Icons.access_time,
              title: 'Deadline Mendekat',
              message: 'Permintaan udang vaname berakhir 2 jam lagi',
              time: '1 jam lalu',
              isNew: true,
            ),
            _item(
              icon: Icons.bookmark,
              title: 'Permintaan Tersimpan',
              message: 'Permintaan tersimpan Anda diperbarui',
              time: '3 jam lalu',
              isNew: false,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _item({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required bool isNew,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNew
            ? CKColors.accentBlue.withAlpha((0.05 * 255).round())
            : CKColors.surfaceSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNew
              ? CKColors.accentBlue.withAlpha((0.2 * 255).round())
              : CKColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CKColors.accentBlue.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: CKColors.accentBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CKColors.textPrimary,
                      ),
                    ),
                    if (isNew) ...[
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 4,
                        backgroundColor: CKColors.accentBlue,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CKColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: CKColors.textHint,
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
