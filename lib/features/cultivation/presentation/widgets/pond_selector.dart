// lib/features/cultivation/presentation/widgets/pond_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/cultivation/domain/models/pond_model.dart'; // Import model
import 'package:proyek_flocify/features/cultivation/presentation/providers/cultivation_providers.dart';
import 'package:proyek_flocify/features/cultivation/presentation/widgets/pond_selection_bottom_sheet.dart';

/// Widget yang menampilkan nama kolam aktif dan berfungsi sebagai tombol
/// untuk membuka bottom sheet pilihan kolam.
class PondSelector extends ConsumerWidget {
  const PondSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ambil data dan state dari provider
    final allPonds = ref.watch(pondListProvider);
    final activePondId = ref.watch(activePondIdProvider);

    // ===============================================================
    // --- PERBAIKAN ERROR 1 & 2 DI SINI ---
    // Cara yang aman untuk menemukan kolam aktif tanpa error tipe.
    Pond? activePond; // Deklarasikan sebagai nullable Pond
    if (activePondId != null && allPonds.isNotEmpty) {
      try {
        // Coba temukan kolam yang cocok.
        activePond = allPonds.firstWhere((pond) => pond.id == activePondId);
      } catch (e) {
        // Jika tidak ditemukan (misal, data tidak sinkron), activePond akan tetap null.
        // Ini mencegah aplikasi crash.
        activePond = null;
      }
    }
    // ===============================================================

    // Tentukan teks yang akan ditampilkan.
    final displayText = activePond?.name ?? 'Pilih Kolam';

    // Bangun UI tombol pemicu
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: InkWell(
        onTap: () {
          PondSelectionBottomSheet.show(context: context);
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF395886),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.08 * 255).round()),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
