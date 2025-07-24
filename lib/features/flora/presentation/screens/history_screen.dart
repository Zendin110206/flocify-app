// Path: lib/features/flora/presentation/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/flora/domain/models/detection_history.dart';
import '../providers/flora_providers.dart';
import '../widgets/history_card.dart'; 
import 'detection_detail_screen.dart';


class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Panggil provider untuk mendapatkan data riwayat secara asinkron
    final historyAsync = ref.watch(detectionHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FA),
      appBar: AppBar(
        // AppBar dari prototype kita pindahkan ke sini
        backgroundColor: const Color(0xFF638ECB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Deteksi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.filter_list, color: Colors.white),
        //     onPressed: () {
        //       // TODO: Implement filter functionality using providers
        //     },
        //   ),
        // ],
      ),
      // 2. Gunakan .when() untuk menangani semua state secara otomatis
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat riwayat: $err')),
        data: (historyList) {
          // 3. Jika tidak ada data, tampilkan pesan
          if (historyList.isEmpty) {
            return const Center(child: Text('Belum ada riwayat deteksi.'));
          }
          
          // 4. Jika ada data, bangun ListView
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final detection = historyList[index];
              return HistoryCard(
                detection: detection,
                onTap: () => _navigateToDetail(context, detection),
              );
            },
          );
        },
      ),
    );
  }

  // Helper method untuk navigasi, sekarang menjadi method statis atau di luar kelas
  void _navigateToDetail(BuildContext context, DetectionHistory detection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetectionDetailScreen(detectionId: detection.id),
      ),
    );
  }
}