// lib/features/home/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_providers.dart';
import '../widgets/home_header.dart';
import '../widgets/report_overview_section.dart';
import '../widgets/category_section.dart';
import '../widgets/new_features_section.dart';
import '../widgets/forum_section.dart';
import '../widgets/news_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pondStatusAsync = ref.watch(pondStatusProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FA),
      body: pondStatusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat data: $err')),
        data: (_) => ListView(
          padding: EdgeInsets.zero,
          children: [
            // DIUBAH: Panggil method baru yang berisi Stack untuk header + search bar
            _buildScrollableHeader(),

            // Sisa konten halaman akan mengikuti di bawahnya
            const ReportOverviewSection(),
            const CategorySection(),
            const NewFeaturesSection(),
            const ForumSection(),
            const NewsSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  
  // BARU: Widget khusus untuk menggabungkan header dan search bar
  // agar posisinya pas seperti desain awal.
  Widget _buildScrollableHeader() {
    // Container ini menentukan area total yang ditempati oleh header dan search bar
    // sebelum konten lain dimulai. Angka 170 adalah hasil penyesuaian agar pas.
    return SizedBox(
      height: 170, 
      child: Stack(
        children: [
          const HomeHeader(),
          
          // Posisi SearchBar sama persis seperti kode awal Anda
          Positioned(
            top: 120,
            left: 24,
            right: 24,
            child: _buildSearchBar(),
          ),
        ],
      ),
    );
  }

  // Widget _buildSearchBar tetap sama, tidak perlu diubah.
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: const [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Mencari sesuatu? Ketik saja...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color.fromARGB(255, 86, 81, 81), fontSize: 16),
              ),
            ),
          ),
          Icon(Icons.search, color: Color.fromARGB(100, 64, 70, 78), size: 20),
        ],
      ),
    );
  }
}