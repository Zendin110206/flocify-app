// lib/screens/cari_kebutuhan.dart
import 'package:flutter/material.dart';

import 'package:proyek_flocify/features/price/presentation/widgets/cari_kebutuhan/ck_colors.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/cari_kebutuhan/ck_search_section.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/cari_kebutuhan/ck_selection_bottom_sheet.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/cari_kebutuhan/ck_results_header.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/cari_kebutuhan/ck_empty_state.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/cari_kebutuhan/ck_request_card.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/cari_kebutuhan/ck_contact_sheet.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/cari_kebutuhan/ck_notifications_sheet.dart';
import 'package:flutter/services.dart';

class CariKebutuhanScreen extends StatefulWidget {
  const CariKebutuhanScreen({super.key});

  @override
  State<CariKebutuhanScreen> createState() => _CariKebutuhanScreenState();
}

class _CariKebutuhanScreenState extends State<CariKebutuhanScreen> {
  final TextEditingController _searchC = TextEditingController();

  String _category = 'Semua';
  String _location = 'Semua Lokasi';
  String _sort = 'Terbaru';
  bool _urgentOnly = false;

  // Mock data sederhana untuk demo UI
  final List<CKRequestData> _all = const [
    CKRequestData(
      title: 'Dicari: Udang Vaname Premium',
      quantity: '2 Ton',
      size: 'Ukuran 50',
      location: 'Indramayu, Jawa Barat',
      pricePerKg: 85000,
      urgent: true,
      pickup: true,
      buyerName: 'PT. Seafood Nusantara',
      buyerType: CKBuyerType.eksportir,
      timeLeftLabel: '3 hari lagi',
    ),
    CKRequestData(
      title: 'Butuh Ikan Lele Konsumsi',
      quantity: '500 kg',
      size: 'Ukuran 8-12',
      location: 'Bandung, Jawa Barat',
      pricePerKg: 18000,
      urgent: false,
      pickup: false,
      buyerName: 'Warung Seafood Bahari',
      buyerType: CKBuyerType.restoran,
      timeLeftLabel: '7 hari lagi',
    ),
    CKRequestData(
      title: 'Cari Ikan Nila Segar',
      quantity: '1.5 Ton',
      size: 'Ukuran 300-500g',
      location: 'Bekasi, Jawa Barat',
      pricePerKg: 22000,
      urgent: false,
      pickup: true,
      buyerName: 'Sumber Rezeki Jaya',
      buyerType: CKBuyerType.tengkulak,
      timeLeftLabel: '5 hari lagi',
    ),
    CKRequestData(
      title: 'Dicari: Kepiting Bakau',
      quantity: '300 kg',
      size: 'Ukuran jumbo',
      location: 'Cirebon, Jawa Barat',
      pricePerKg: 45000,
      urgent: true,
      pickup: true,
      buyerName: 'Marine Export Co.',
      buyerType: CKBuyerType.eksportir,
      timeLeftLabel: '2 hari lagi',
    ),
  ];

  final _categories = const [
    'Semua',
    'Udang Vaname',
    'Ikan Lele',
    'Ikan Nila',
    'Ikan Gurame',
    'Kepiting',
    'Bandeng',
  ];

  final _locations = const [
    'Semua Lokasi',
    'Jawa Barat',
    'Jawa Tengah',
    'Jawa Timur',
    'Banten',
    'DKI Jakarta',
  ];

  final _sorts = const [
    'Terbaru',
    'Deadline Terdekat',
    'Harga Tertinggi',
    'Harga Terendah',
    'Kuantitas Terbesar',
  ];

  List<CKRequestData> get _filtered {
    final q = _searchC.text.trim().toLowerCase();

    List<CKRequestData> list = _all.where((e) {
      final matchSearch =
          q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.buyerName.toLowerCase().contains(q);

      final matchUrgent = !_urgentOnly || e.urgent;

      // Category demo sederhana: cocokkan kata pada title
      bool matchCategory = true;
      if (_category != 'Semua') {
        matchCategory = e.title.toLowerCase().contains(_category.toLowerCase());
      }

      // Location demo: cek provinsi
      bool matchLocation = true;
      if (_location != 'Semua Lokasi') {
        matchLocation = e.location.toLowerCase().contains(
          _location.toLowerCase(),
        );
      }

      return matchSearch && matchUrgent && matchCategory && matchLocation;
    }).toList();

    // Sort demo UI
    switch (_sort) {
      case 'Harga Tertinggi':
        list.sort((a, b) => b.pricePerKg.compareTo(a.pricePerKg));
        break;
      case 'Harga Terendah':
        list.sort((a, b) => a.pricePerKg.compareTo(b.pricePerKg));
        break;
      // Deadline Terdekat & Kuantitas Terbesar: mock data tidak punya numeric pasti.
      default:
        // Terbaru – biarkan urutan aslinya
        break;
    }

    return list;
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CKColors.backgroundBlue,
      appBar: AppBar(
        // pakai CKHeader style: latar transparan + judul putih
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleSpacing: 0,
        title: const Text(
          'Cari Kebutuhan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () => CKNotificationsSheet.show(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search + Chips
          CKSearchSection(
            controller: _searchC,
            onClearSearch: () {
              _searchC.clear();
              setState(() {});
            },
            onSearchChanged: (_) => setState(() {}),
            categoryLabel: _category,
            locationLabel: _location,
            sortLabel: _sort,
            urgentOnly: _urgentOnly,
            onTapCategory: () => CKSelectionBottomSheet.show(
              context: context,
              title: 'Pilih Kategori',
              items: _categories,
              currentValue: _category,
              onSelected: (v) => setState(() => _category = v),
            ),
            onTapLocation: () => CKSelectionBottomSheet.show(
              context: context,
              title: 'Pilih Lokasi',
              items: _locations,
              currentValue: _location,
              onSelected: (v) => setState(() => _location = v),
            ),
            onTapSort: () => CKSelectionBottomSheet.show(
              context: context,
              title: 'Urutkan Berdasarkan',
              items: _sorts,
              currentValue: _sort,
              onSelected: (v) => setState(() => _sort = v),
            ),
            onToggleUrgent: () => setState(() => _urgentOnly = !_urgentOnly),
          ),

          // Panel putih ber-radius untuk isi
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: CKColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  CKResultsHeader(count: _filtered.length),
                  Expanded(
                    child: _filtered.isEmpty
                        ? const CKEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async {
                              await Future.delayed(
                                const Duration(milliseconds: 800),
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Data berhasil diperbarui',
                                  ),
                                  backgroundColor: CKColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              itemCount: _filtered.length,
                              itemBuilder: (context, i) {
                                final d = _filtered[i];
                                return CKRequestCard(
                                  data: d,
                                  onContact: () => CKContactSheet.show(
                                    context: context,
                                    buyerName: d.buyerName,
                                    onPhone: () => _toast(
                                      'Menghubungkan ke ${d.buyerName}…',
                                    ),
                                    onWhatsApp: () =>
                                        _toast('Membuka WhatsApp…'),
                                    onEmail: () =>
                                        _toast('Membuka aplikasi email…'),
                                  ),
                                  onBookmark: () =>
                                      _toast('Permintaan disimpan'),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _toast('Fitur buat permintaan segera hadir'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add),
        label: const Text('Buat Permintaan'),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: CKColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
