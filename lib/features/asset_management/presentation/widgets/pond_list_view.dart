// Path: lib/features/asset_management/presentation/widgets/pond_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/asset_models.dart';
import 'pond_tile.dart'; // Widget ini akan kita buat selanjutnya
import 'empty_state_widget.dart'; // Widget ini juga akan kita buat

// Provider dummy untuk data ponds.
// Nanti, ini akan diganti dengan yang mengambil data dari Firestore.
final pondListProvider = Provider<List<PondModel>>((ref) {
  return const [
    PondModel(
      id: '1',
      name: "Kolam Lele 1",
      commodity: "Lele",
      connectedDevice: "Alat di Kolam Utama",
      area: "500 m²",
      status: PondStatus.healthy,
      fishCount: 2500,
    ),
    PondModel(
      id: '2',
      name: "Kolam Gurame 1",
      commodity: "Gurame",
      connectedDevice: null,
      area: "300 m²",
      status: PondStatus.warning,
      fishCount: 800,
    ),
    PondModel(
      id: '3',
      name: "Kolam Nila Premium",
      commodity: "Nila",
      connectedDevice: null,
      area: "750 m²",
      status: PondStatus.disconnected,
      fishCount: 3200,
    ),
  ];
});

class PondListView extends ConsumerWidget {
  const PondListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Tonton (watch) provider untuk mendapatkan daftar kolam.
    final ponds = ref.watch(pondListProvider);

    // 2. Jika daftar kolam kosong, tampilkan widget empty state.
    if (ponds.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.water_outlined,
        title: "Belum Ada Kolam",
        subtitle:
            "Buat kolam budidaya digital pertama Anda dengan menekan tombol (+).",
      );
    }

    // 3. Jika ada data, gunakan ListView.separated.
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        90,
      ), // Padding bawah untuk FAB
      itemCount: ponds.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pond = ponds[index];
        // Setiap item di daftar akan dirender oleh PondTile
        return PondTile(pond: pond);
      },
    );
  }
}
