import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/settings_menu_item.dart';
import 'package:proyek_flocify/features/presets/presentation/screens/preset_list_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // Kita gunakan warna background yang konsisten dengan halaman lain
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        // AppBar untuk judul halaman
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withAlpha((0.05 * 255).round()),
        // Kita tidak butuh tombol kembali karena ini adalah halaman utama di tab
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          // --- Grup Akun ---
          _buildGroupHeader('Akun'),
          SettingsMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profil',
            onTap: () {
              /* TODO: Navigasi ke halaman Edit Profil */
            },
          ),
          SettingsMenuItem(
            icon: Icons.lock_outline,
            title: 'Keamanan & Login',
            onTap: () {
              /* TODO: Navigasi ke halaman Keamanan */
            },
          ),
          const Divider(),

          // --- Grup Konfigurasi ---
          _buildGroupHeader('Konfigurasi'),
          SettingsMenuItem(
            icon: Icons.biotech_outlined,
            title: 'Preset Budidaya',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PresetListScreen(),
                ),
              );
            },
          ),
          SettingsMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Manajemen Notifikasi',
            onTap: () {
              /* TODO: Navigasi ke halaman Notifikasi */
            },
          ),
          const Divider(),

          // --- Grup Bantuan & Informasi ---
          _buildGroupHeader('Bantuan & Informasi'),
          SettingsMenuItem(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan',
            onTap: () {
              /* TODO: Navigasi ke Pusat Bantuan */
            },
          ),
          SettingsMenuItem(
            icon: Icons.support_agent_outlined,
            title: 'Hubungi Dukungan',
            onTap: () {
              /* TODO: Navigasi ke Hubungi Dukungan */
            },
          ),
          SettingsMenuItem(
            icon: Icons.info_outline,
            title: 'Tentang Flocify',
            onTap: () {
              /* TODO: Navigasi ke halaman Tentang */
            },
          ),
          const Divider(),

          // --- Aksi Logout ---
          SettingsMenuItem(
            icon: Icons.logout,
            title: 'Keluar',
            iconColor: Colors.red, // Contoh kustomisasi warna
            onTap: () {
              /* TODO: Tampilkan dialog konfirmasi logout */
            },
          ),
        ],
      ),
    );
  }

  // Method helper untuk membuat header grup agar kode lebih rapi
  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
