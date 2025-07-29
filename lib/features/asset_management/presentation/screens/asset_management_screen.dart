// Path: lib/features/asset_management/presentation/screens/asset_management_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/asset_header.dart';
import '../widgets/device_list_view.dart';
import '../widgets/pond_list_view.dart';
import '../widgets/add_asset_button.dart';
import 'package:proyek_flocify/features/device_registration/presentation/screens/scan_qr_screen.dart';
import 'package:proyek_flocify/features/pond_creation/presentation/screens/create_pond_screen.dart';

class AssetManagementScreen extends ConsumerStatefulWidget {
  const AssetManagementScreen({super.key});

  @override
  ConsumerState<AssetManagementScreen> createState() =>
      _AssetManagementScreenState();
}

class _AssetManagementScreenState extends ConsumerState<AssetManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // === TAMBAHKAN METHOD INI DI DALAM _AssetManagementScreenState ===

  // === GANTI KODE DI DALAM _showAddAssetSheet ===

  void _showAddAssetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      // Gunakan isScrollControlled jika konten bisa lebih tinggi dari setengah layar
      isScrollControlled: true,
      builder: (context) {
        // SafeArea akan secara otomatis memberikan padding yang diperlukan
        // untuk menghindari system intrusions seperti navigation bar.
        return SafeArea(
          child: Padding(
            // Kita masih bisa memberikan padding kustom kita sendiri
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle abu-abu di atas
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tambah Aset Baru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Tombol untuk Tambah Perangkat
                    AddAssetButton(
                      title: 'Perangkat',
                      subtitle: 'Daftarkan alat monitoring baru',
                      icon: Icons
                          .qr_code_scanner_rounded, // Icon yang lebih sesuai
                      color: const Color(0xFF638ECB),
                      onTap: () {
                        Navigator.pop(context);
                        _showAddDeviceFlow();
                      },
                    ),
                    const SizedBox(width: 16),
                    // Tombol untuk Tambah Kolam
                    AddAssetButton(
                      title: 'Kolam',
                      subtitle: 'Buat kolam budidaya digital',
                      icon: Icons
                          .add_location_alt_outlined, // Icon yang lebih sesuai
                      color: const Color(0xFF3B82F6),
                      onTap: () {
                        Navigator.pop(context);
                        _showAddPondFlow();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // === TAMBAHKAN JUGA METHOD-METHOD INI ===

  void _showAddDeviceFlow() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanQrScreen()),
    );
  }

  void _showAddPondFlow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePondScreen(),
        // fullscreenDialog: true, // Opsional: untuk transisi dari bawah ke atas
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kita tetap butuh data ini untuk di-pass ke AssetHeader
    final devices = ref.watch(deviceListProvider);
    final ponds = ref.watch(pondListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ✅ Bagian atas: gradient, greeting, quick‑status, TabBar
          AssetHeader(
            devices: devices,
            ponds: ponds,
            tabController: _tabController,
          ),

          // ✅ Bagian bawah: konten tiap tab – dimasukkan ke Expanded
          Expanded(
            child: ClipRect(
              child: TabBarView(
                controller: _tabController,
                children: const [DeviceListView(), PondListView()],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAssetSheet(context), // Panggil method kita
        // ... sisa kode
        backgroundColor: const Color(0xFF638ECB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Aset'),
      ),
    );
  }
}
