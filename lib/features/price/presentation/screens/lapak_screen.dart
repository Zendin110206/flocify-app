// lib/screens/lapak_screen.dart
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // tidak dipakai di file ini
// import 'package:intl/intl.dart'; // belum dipakai, nanti ditambah lagi saat render harga

import 'package:proyek_flocify/features/price/presentation/widgets/lapak/lapak_header.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/filter_row.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/selection_bottom_sheet.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/top_toolbar.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/simple_list.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/detail_list.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/filter_pills_bar.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/empty_state.dart';

// =======================
// MODEL (tetap di screen)
// =======================
class LapakData {
  final String lokasi;
  final String size;
  final int harga;
  final String tanggal;
  final String contributor;
  final String imageUrl;
  final String deskripsi;
  final double tonase;
  final double rating;
  final int reviewCount;
  final String jenisIkan;
  final String kualitas;
  final bool isVerified;
  final String estimasi;
  final String ukuran;

  LapakData({
    required this.lokasi,
    required this.size,
    required this.harga,
    required this.tanggal,
    required this.contributor,
    this.imageUrl = '',
    this.deskripsi = '',
    this.tonase = 0.0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.jenisIkan = '',
    this.kualitas = '',
    this.isVerified = false,
    this.estimasi = '',
    this.ukuran = '',
  });
}

class LapakScreen extends StatefulWidget {
  const LapakScreen({super.key});

  @override
  State<LapakScreen> createState() => _LapakScreenState();
}

class _LapakScreenState extends State<LapakScreen> {
  String selectedKomoditas = 'Semua';
  String selectedLokasi = 'Semua';
  String selectedSize = 'Semua Size';
  String selectedSort = 'Terbaru'; // default
  bool isDetailView = false;

  String get _sortLabelShort {
    switch (selectedSort) {
      case 'Harga Termurah':
        return 'Murah';
      case 'Harga Tertinggi':
        return 'Mahal';
      case 'Rating Tertinggi':
        return 'Rating↑';
      case 'Rating Terendah':
        return 'Rating↓';
      default:
        return 'Terbaru';
    }
  }

  final List<String> sortOptions = [
    'Terbaru', // tanggal desc - seperti sekarang
    'Harga Termurah',
    'Harga Tertinggi',
    'Rating Tertinggi',
    'Rating Terendah',
  ];

  final List<String> komoditasList = [
    'Semua',
    'Nila',
    'Lele',
    'Gurame',
    'Udang',
    'Patin',
    'Mas',
    'Bawal',
    'Mujair',
  ];

  final List<String> lokasiList = [
    'Semua',
    'Bandung',
    'Jakarta',
    'Surabaya',
    'Medan',
    'Semarang',
    'Yogyakarta',
    'Malang',
    'Bogor',
    'Depok',
    'Bekasi',
    'Tangerang',
    'Cirebon',
    'Solo',
    'Palembang',
    'Makassar',
  ];

  final List<String> sizeList = [
    'Size: 80',
    'Size: 100',
    'Size: 120',
    'Size: 150',
    'Size: 200',
    'Semua Size',
  ];

  // ignore: unused_field
  final List<LapakData> _lapakItems = [
    // ===== NILA =====
    LapakData(
      lokasi: 'Bandung',
      size: 'Size: 100',
      harga: 18000,
      tanggal: '04 Jul 2025',
      contributor: 'Asep Jamaludin',
      imageUrl: 'assets/images/nila1.jpg',
      deskripsi:
          'Ikan nila segar dari kolam sendiri, bebas dari bahan kimia berbahaya',
      tonase: 2.5,
      rating: 4.8,
      reviewCount: 124,
      jenisIkan: 'Nila Merah',
      kualitas: 'Grade A',
      isVerified: true,
      estimasi: 'Estimasi 2.5 ton, ukuran 8-10 ekor/kg',
      ukuran: '8-10 ekor/kg',
    ),
    LapakData(
      lokasi: 'Bandung',
      size: 'Size: 120',
      harga: 19000,
      tanggal: '04 Jul 2025',
      contributor: 'Budi Santoso',
      imageUrl: 'assets/images/nila2.jpg',
      deskripsi:
          'Nila berkualitas tinggi dengan ukuran seragam. Cocok untuk restoran',
      tonase: 3.0,
      rating: 4.6,
      reviewCount: 89,
      jenisIkan: 'Nila Hitam',
      kualitas: 'Grade A',
      isVerified: true,
      estimasi: 'Estimasi 3.0 ton, ukuran 6-8 ekor/kg',
      ukuran: '6-8 ekor/kg',
    ),
    LapakData(
      lokasi: 'Jakarta',
      size: 'Size: 100',
      harga: 17500,
      tanggal: '04 Jul 2025',
      contributor: 'Citra Dewi',
      imageUrl: 'assets/images/nila3.jpg',
      deskripsi: 'Ikan nila organik hasil budidaya ramah lingkungan',
      tonase: 1.8,
      rating: 4.7,
      reviewCount: 67,
      jenisIkan: 'Nila Gift',
      kualitas: 'Grade B+',
      isVerified: false,
      estimasi: 'Estimasi 1.8 ton, ukuran 10-12 ekor/kg',
      ukuran: '10-12 ekor/kg',
    ),

    // ===== LELE =====
    LapakData(
      lokasi: 'Indramayu, Jawa Barat',
      size: 'Size: 80',
      harga: 16500,
      tanggal: '10 Agustus 2024',
      contributor: 'Deni Kurniawan',
      imageUrl: 'assets/images/lele1.jpg',
      deskripsi: 'Lele Konsumsi Siap Panen',
      tonase: 1.5,
      rating: 4.8,
      reviewCount: 156,
      jenisIkan: 'Lele Konsumsi',
      kualitas: 'Grade A',
      isVerified: true,
      estimasi: 'Estimasi 1.5 ton, ukuran 8-10 ekor/kg',
      ukuran: '8-10 ekor/kg',
    ),
    LapakData(
      lokasi: 'Surabaya',
      size: 'Size: 120',
      harga: 16000,
      tanggal: '06 Jul 2025',
      contributor: 'Rudi Hartono',
      imageUrl: '',
      deskripsi: 'Lele segar kualitas konsumsi, pakan terkontrol',
      tonase: 2.0,
      rating: 4.5,
      reviewCount: 54,
      jenisIkan: 'Lele Jumbo',
      kualitas: 'Grade A-',
      isVerified: false,
      estimasi: 'Estimasi 2.0 ton, ukuran 6-8 ekor/kg',
      ukuran: '6-8 ekor/kg',
    ),

    // ===== PATIN =====
    LapakData(
      lokasi: 'Surabaya',
      size: 'Size: 100',
      harga: 18500,
      tanggal: '05 Jul 2025',
      contributor: 'Slamet Riyadi',
      imageUrl: '',
      deskripsi: 'Patin konsumsi, ukuran seragam',
      tonase: 2.2,
      rating: 4.4,
      reviewCount: 38,
      jenisIkan: 'Patin',
      kualitas: 'Grade A',
      isVerified: true,
      estimasi: 'Estimasi 2.2 ton, ukuran 8-10 ekor/kg',
      ukuran: '8-10 ekor/kg',
    ),
    LapakData(
      lokasi: 'Semarang',
      size: 'Size: 150',
      harga: 19500,
      tanggal: '07 Jul 2025',
      contributor: 'Agus Saputra',
      imageUrl: '',
      deskripsi: 'Patin segar, cocok untuk restoran & catering',
      tonase: 1.6,
      rating: 4.2,
      reviewCount: 21,
      jenisIkan: 'Patin Super',
      kualitas: 'Grade A',
      isVerified: false,
      estimasi: 'Estimasi 1.6 ton, ukuran 5-7 ekor/kg',
      ukuran: '5-7 ekor/kg',
    ),

    // ===== GURAME =====
    LapakData(
      lokasi: 'Bogor',
      size: 'Size: 120',
      harga: 48000,
      tanggal: '06 Jul 2025',
      contributor: 'Hendra Wijaya',
      imageUrl: '',
      deskripsi: 'Gurame konsumsi premium',
      tonase: 0.8,
      rating: 4.9,
      reviewCount: 12,
      jenisIkan: 'Gurame',
      kualitas: 'Grade A',
      isVerified: true,
      estimasi: 'Estimasi 0.8 ton, ukuran 3-4 ekor/kg',
      ukuran: '3-4 ekor/kg',
    ),

    // ===== UDANG =====
    LapakData(
      lokasi: 'Makassar',
      size: 'Size: 100',
      harga: 68000,
      tanggal: '05 Jul 2025',
      contributor: 'Farhan Akbar',
      imageUrl: '',
      deskripsi: 'Udang Vaname segar, tebar padat bioflok',
      tonase: 1.2,
      rating: 4.7,
      reviewCount: 40,
      jenisIkan: 'Udang Vaname',
      kualitas: 'Grade A',
      isVerified: true,
      estimasi: 'Estimasi 1.2 ton, ukuran 80-100 ekor/kg',
      ukuran: '80-100 ekor/kg',
    ),
    LapakData(
      lokasi: 'Medan',
      size: 'Size: 120',
      harga: 64000,
      tanggal: '06 Jul 2025',
      contributor: 'Andi Prabowo',
      imageUrl: '',
      deskripsi: 'Udang Vaname kualitas ekspor',
      tonase: 1.0,
      rating: 4.6,
      reviewCount: 33,
      jenisIkan: 'Udang Vaname',
      kualitas: 'Grade A-',
      isVerified: false,
      estimasi: 'Estimasi 1.0 ton, ukuran 60-80 ekor/kg',
      ukuran: '60-80 ekor/kg',
    ),

    // ===== MAS =====
    LapakData(
      lokasi: 'Yogyakarta',
      size: 'Size: 200',
      harga: 22000,
      tanggal: '04 Jul 2025',
      contributor: 'Bayu Wicaksono',
      imageUrl: '',
      deskripsi: 'Ikan Mas konsumsi',
      tonase: 2.0,
      rating: 4.1,
      reviewCount: 25,
      jenisIkan: 'Ikan Mas',
      kualitas: 'Grade B+',
      isVerified: false,
      estimasi: 'Estimasi 2.0 ton, ukuran 4-5 ekor/kg',
      ukuran: '4-5 ekor/kg',
    ),
    LapakData(
      lokasi: 'Cirebon',
      size: 'Size: 150',
      harga: 21000,
      tanggal: '08 Jul 2025',
      contributor: 'Ujang Rohman',
      imageUrl: '',
      deskripsi: 'Ikan Mas konsumsi segar',
      tonase: 1.3,
      rating: 4.0,
      reviewCount: 11,
      jenisIkan: 'Ikan Mas',
      kualitas: 'Grade B+',
      isVerified: false,
      estimasi: 'Estimasi 1.3 ton, ukuran 5-6 ekor/kg',
      ukuran: '5-6 ekor/kg',
    ),
  ];

  List<LapakData> get _filteredItems {
    final kom = selectedKomoditas.toLowerCase();
    final lok = selectedLokasi.toLowerCase();
    final size = selectedSize;

    return _lapakItems.where((e) {
      // Komoditas: jika "Semua" -> lolos
      final matchKomoditas = (kom == 'semua')
          ? true
          : e.jenisIkan.toLowerCase().contains(kom);

      // Lokasi: jika "Semua" -> lolos, else contains
      final matchLokasi = (lok == 'semua')
          ? true
          : e.lokasi.toLowerCase().contains(lok);

      // Size: jika "Semua Size" -> lolos, else harus persis sama
      final matchSize = (size == 'Semua Size') ? true : e.size == size;

      return matchKomoditas && matchLokasi && matchSize;
    }).toList();
  }

  List<LapakData> get _sortedFilteredItems {
    final list = _filteredItems;

    switch (selectedSort) {
      case 'Harga Termurah':
        list.sort((a, b) => a.harga.compareTo(b.harga));
        break;
      case 'Harga Tertinggi':
        list.sort((a, b) => b.harga.compareTo(a.harga));
        break;
      case 'Rating Tertinggi':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Rating Terendah':
        list.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      default: // 'Terbaru' – tanggal descending (string yyyy... aman)
        list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    }
    return list;
  }

  // === Helper untuk membuka bottom sheet (UI sama persis) ===
  void _openSelection({
    required String title,
    required List<String> items,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    LapakSelectionBottomSheet.show(
      context: context,
      title: title,
      items: items,
      currentValue: currentValue,
      onSelected: onSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF638ECB),
      appBar: const LapakHeader(),
      body: Column(
        children: [
          // === Filter Row (Komoditas & Lokasi) ===
          LapakFilterRow(
            komoditas: selectedKomoditas,
            lokasi: selectedLokasi,
            onTapKomoditas: () => _openSelection(
              title: 'Komoditas',
              items: komoditasList,
              currentValue: selectedKomoditas,
              onSelected: (v) => setState(() => selectedKomoditas = v),
            ),
            onTapLokasi: () => _openSelection(
              title: 'Lokasi',
              items: lokasiList,
              currentValue: selectedLokasi,
              onSelected: (v) => setState(() => selectedLokasi = v),
            ),
          ),

          // ====== Placeholder konten, akan kita pecah di step berikutnya ======
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // TOP TOOLBAR
                  LapakTopToolbar(
                    komoditas: selectedKomoditas,
                    isDetailView: isDetailView,
                    onTapListView: () => setState(() => isDetailView = false),
                    onTapDetailView: () => setState(() => isDetailView = true),
                    onTapInputHarga: () {
                      // TODO: aksi Input Harga
                    },
                    // baru
                    sortLabel: _sortLabelShort,
                    onTapSort: () => _openSelection(
                      title: 'Urut Berdasarkan',
                      items: sortOptions,
                      currentValue: selectedSort,
                      onSelected: (v) => setState(() => selectedSort = v),
                    ),
                  ),

                  // LIST (simple/detail) dengan animasi
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Builder(
                        builder: (context) {
                          final items = _sortedFilteredItems;

                          if (items.isEmpty) {
                            return LapakEmptyState(
                              message:
                                  'Tidak ada ${selectedKomoditas.toLowerCase()} di $selectedLokasi untuk $selectedSize. '
                                  'Coba ubah filter komoditas, lokasi, atau size.',
                              onUbahFilter: () => _openSelection(
                                title: 'Komoditas',
                                items: komoditasList,
                                currentValue: selectedKomoditas,
                                onSelected: (v) =>
                                    setState(() => selectedKomoditas = v),
                              ),
                            );
                          }

                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: isDetailView
                                ? LapakDetailList(
                                    key: const ValueKey('detail'),
                                    items: items,
                                  )
                                : LapakSimpleList(
                                    key: const ValueKey('simple'),
                                    items: items,
                                  ),
                          );
                        },
                      ),
                    ),
                  ),

                  // FILTER PILLS BAR (di bawah)
                  SafeArea(
                    top: false,
                    minimum: const EdgeInsets.only(bottom: 16),
                    child: LapakFilterPillsBar(
                      sizeLabel: selectedSize,
                      onTapSize: () => _openSelection(
                        title: 'Size',
                        items: sizeList,
                        currentValue: selectedSize,
                        onSelected: (v) => setState(() => selectedSize = v),
                      ),
                      onTapCariLokasi: () => _openSelection(
                        title: 'Lokasi',
                        items: lokasiList,
                        currentValue: selectedLokasi,
                        onSelected: (v) => setState(() => selectedLokasi = v),
                      ),

                      // === Tampilkan tombol Reset hanya jika ada filter aktif ===
                      showReset:
                          !(selectedKomoditas.toLowerCase() == 'semua' &&
                              selectedLokasi.toLowerCase() == 'semua' &&
                              selectedSize == 'Semua Size'),
                      onReset: () {
                        setState(() {
                          selectedKomoditas = 'Semua';
                          selectedLokasi = 'Semua';
                          selectedSize = 'Semua Size';
                        });

                        // (opsional) beri feedback ringan
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Filter direset ke Semua'),
                            duration: Duration(milliseconds: 1200),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
