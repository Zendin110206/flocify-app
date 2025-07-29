// lib/widgets/cari_kebutuhan/ck_contact_sheet.dart
import 'package:flutter/material.dart';
import 'ck_colors.dart';

// …import tetap

class CKContactSheet {
  static Future<void> show({
    required BuildContext context,
    required String buyerName,
    required VoidCallback onPhone,
    required VoidCallback onWhatsApp,
    required VoidCallback onEmail,
  }) {

    return showModalBottomSheet(
      context: context,
      backgroundColor: CKColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final media = MediaQuery.of(context);
        final safeBottom = media.padding.bottom;

        // >>> penting: jangan pakai SafeArea bottom
        return SafeArea(
          top: false,
          bottom: false, // <-- ini kunci: jangan tambah inset otomatis
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 8,
              // jika ada gesture bar pakai nilainya, kalau tidak, 0
              bottom:
                  safeBottom, // <-- dari sebelumnya 4 / ternary -> jadi langsung safeBottom
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // handle bar
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),

                Text(
                  'Hubungi $buyerName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CKColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                _item(
                  icon: Icons.phone,
                  iconBg: const Color(0xFF25D366),
                  title: 'Telepon',
                  subtitle: 'Hubungi langsung via telepon',
                  onTap: () {
                    Navigator.pop(context);
                    onPhone();
                  },
                ),
                _item(
                  icon: Icons.message,
                  iconBg: const Color(0xFF25D366),
                  title: 'WhatsApp',
                  subtitle: 'Chat via WhatsApp',
                  onTap: () {
                    Navigator.pop(context);
                    onWhatsApp();
                  },
                ),
                _item(
                  icon: Icons.email,
                  iconBg: CKColors.accentBlue,
                  title: 'Email',
                  subtitle: 'Kirim email penawaran',
                  onTap: () {
                    Navigator.pop(context);
                    onEmail();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ——— LIST ITEM ———
  static Widget _item({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      // dense di-hapus → tinggi kembali normal
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(
        vertical: -1,
      ), // sedikit padat, tapi tidak sekecil sebelumnya
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBg.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconBg),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16, // <<< kembali 16 pt
          fontWeight: FontWeight.w600,
          color: CKColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13, color: CKColors.textSecondary),
      ),
      onTap: onTap,
    );
  }
}
