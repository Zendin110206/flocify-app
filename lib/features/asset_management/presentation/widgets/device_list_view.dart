// Path: lib/features/asset_management/presentation/widgets/device_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/asset_models.dart';
import 'device_tile.dart'; // Widget ini akan kita buat selanjutnya
import 'empty_state_widget.dart'; // Widget ini juga

// Provider dummy untuk data devices. Kita pindahkan ke sini agar widget ini mandiri.
// Nanti, provider ini akan kita ganti dengan yang mengambil data dari Firestore.
final deviceListProvider = Provider<List<DeviceModel>>((ref) {
  return const [
    DeviceModel(
      id: '1',
      name: "Alat di Kolam Utama",
      status: DeviceStatus.online,
      sensors: ["pH", "Suhu", "Amonia"],
      lastSeen: "2 menit lalu",
    ),
    DeviceModel(
      id: '2',
      name: "Alat di Gudang",
      status: DeviceStatus.offline,
      sensors: ["pH", "Suhu"],
      lastSeen: "3 jam lalu",
    ),
    DeviceModel(
      id: '3',
      name: "Sensor Kolam 2",
      status: DeviceStatus.online,
      sensors: ["pH", "Suhu", "DO", "Turbidity"],
      lastSeen: "1 hari lalu",
    ),
    DeviceModel(
      id: '4',
      name: "Alat di bjirrr",
      status: DeviceStatus.online,
      sensors: ["pH", "Suhu"],
      lastSeen: "3 jam lalu",
    ),
    DeviceModel(
      id: '5',
      name: "Alat di babi",
      status: DeviceStatus.offline,
      sensors: ["pH", "Suhu"],
      lastSeen: "5 jam lalu",
    ),
  ];
});

class DeviceListView extends ConsumerWidget {
  const DeviceListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Tonton (watch) provider untuk mendapatkan daftar perangkat.
    final devices = ref.watch(deviceListProvider);

    // 2. Jika daftar perangkat kosong, tampilkan widget empty state.
    if (devices.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.router_outlined,
        title: "Belum Ada Perangkat",
        subtitle:
            "Tambahkan perangkat Flocify Board pertama Anda dengan menekan tombol (+).",
      );
    }

    // 3. Jika ada data, gunakan ListView.separated untuk membuat daftar.
    //    Ini lebih efisien daripada Column di dalam SingleChildScrollView.
    return ListView.separated(
      // Beri padding agar tidak menempel di tepi layar
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        90,
      ), // Padding bawah agar tidak tertutup FAB
      itemCount: devices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final device = devices[index];
        // Setiap item di daftar akan dirender oleh DeviceTile
        return DeviceTile(device: device);
      },
    );
  }
}
