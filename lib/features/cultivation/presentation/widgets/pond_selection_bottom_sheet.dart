// lib/features/cultivation/presentation/widgets/pond_selection_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/cultivation/domain/models/pond_model.dart';
import 'package:proyek_flocify/features/cultivation/presentation/providers/cultivation_providers.dart';

/// Bottom sheet canggih untuk memilih kolam, dengan gaya yang konsisten
/// di seluruh aplikasi.
///
/// Dipanggil melalui method static `show()` untuk kemudahan penggunaan.
class PondSelectionBottomSheet {
  static Future<void> show({required BuildContext context}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // Gunakan Consumer untuk mendapatkan akses ke `ref` di dalam builder
        return Consumer(
          builder: (context, ref, _) {
            final media = MediaQuery.of(context);
            final ponds = ref.watch(pondListProvider);

            // --- Logika tinggi adaptif berdasarkan jumlah item ---
            double factor;
            final count = ponds.length;
            if (count <= 3) {
              factor = 0.45; // Sangat pendek
            } else if (count <= 5) {
              factor = 0.60; // Sedang
            } else if (count <= 8) {
              factor = 0.75; // Cukup tinggi
            } else {
              factor = 0.85; // Maksimal, untuk list panjang
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuad,
              height: media.size.height * factor,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.15 * 255).round()),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: _PondSelectionContent(ponds: ponds),
            );
          },
        );
      },
    );
  }
}

/// Widget internal yang Stateful untuk mengelola state pencarian secara lokal.
class _PondSelectionContent extends ConsumerStatefulWidget {
  final List<Pond> ponds;
  const _PondSelectionContent({required this.ponds});

  @override
  ConsumerState<_PondSelectionContent> createState() =>
      _PondSelectionContentState();
}

class _PondSelectionContentState extends ConsumerState<_PondSelectionContent> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() {
        if (mounted) {
          setState(() {
            _searchQuery = _searchController.text.toLowerCase();
          });
        }
      });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    const themeColor = Color(0xFF638ECB);

    final filteredPonds = widget.ponds.where((pond) {
      return _searchQuery.isEmpty ||
          pond.name.toLowerCase().contains(_searchQuery);
    }).toList();

    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          // Header
          _buildHeader(themeColor, widget.ponds.length),
          // Search Bar
          _buildSearchBar(),
          // Divider
          _buildDivider(),
          // List Items
          _buildPondList(filteredPonds, safeBottom, themeColor),
        ],
      ),
    );
  }

  Widget _buildHeader(Color themeColor, int totalPonds) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: themeColor.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.water_drop_outlined, color: themeColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Kolam',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalPonds pilihan tersedia',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.close, size: 22, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari nama kolam...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      // TAMBAH: margin vertikal untuk jarak seimbang atas-bawah
      margin: const EdgeInsets.only(top: 6.0),
      height: 2,
      color: Colors.grey[200],
    );
  }

  Widget _buildPondList(List<Pond> ponds, double safeBottom, Color themeColor) {
    final activePondId = ref.watch(activePondIdProvider);

    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(8, 8, 8, safeBottom + 8),
        itemCount: ponds.length,
        itemBuilder: (context, index) {
          final pond = ponds[index];
          final isSelected = pond.id == activePondId;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(activePondIdProvider.notifier).state = pond.id;
                  Navigator.pop(context);
                },
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? themeColor.withAlpha((0.08 * 255).round())
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(
                            color: themeColor.withAlpha((0.30 * 255).round()),
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Radio-like indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? themeColor : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? themeColor : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                      // Text label
                      Expanded(
                        child: Text(
                          pond.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected ? themeColor : Colors.black87,
                          ),
                        ),
                      ),
                      // Trailing icon if selected
                      if (isSelected)
                        Icon(
                          Icons.arrow_forward_ios,
                          color: themeColor,
                          size: 14,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
