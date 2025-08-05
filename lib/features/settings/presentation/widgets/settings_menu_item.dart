import 'package:flutter/material.dart';

class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor; // Opsional untuk kustomisasi warna

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Gunakan InkWell untuk efek ripple yang bagus saat diketuk
      onTap: onTap,
      leading: Icon(
        icon,
        color:
            iconColor ??
            Colors.grey[700], // Warna default jika tidak dispesifikasi
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }
}
