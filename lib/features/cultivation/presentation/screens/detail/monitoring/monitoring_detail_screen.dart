// lib/features/cultivation/presentation/screens/detail/monitoring/monitoring_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Gunakan ConsumerWidget agar bisa mengakses data dari provider nanti
class MonitoringDetailScreen extends ConsumerWidget {
  // 1. Properti untuk menerima ID kolam yang aktif
  final String pondId;

  // 2. Buat konstruktor yang mewajibkan pondId
  const MonitoringDetailScreen({super.key, required this.pondId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Monitoring'),
        // Style AppBar agar konsisten
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF0F3FA),
      body: Center(
        // 3. Tampilkan ID untuk memastikan data berhasil dikirim
        child: Text(
          'Menampilkan data monitoring untuk Kolam ID: $pondId',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
