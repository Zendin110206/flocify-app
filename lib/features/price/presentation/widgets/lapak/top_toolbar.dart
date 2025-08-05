//lib/features/price/presentation/widgets/lapak/top_toolbar.dart
import 'package:flutter/material.dart';

const _linkColor = Color(0xFF638ECB);

class LapakTopToolbar extends StatelessWidget {
  final String komoditas;
  final bool isDetailView;
  final VoidCallback onTapListView;
  final VoidCallback onTapDetailView;
  final VoidCallback onTapInputHarga;

  /// Label pendek: Terbaru / Murah / Mahal / Rating↑ / Rating↓
  final String sortLabel;
  final VoidCallback onTapSort;

  const LapakTopToolbar({
    super.key,
    required this.komoditas,
    required this.isDetailView,
    required this.onTapListView,
    required this.onTapDetailView,
    required this.onTapInputHarga,
    required this.sortLabel,
    required this.onTapSort,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Baris 1: Judul + Input Harga (kanan) =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul lebar (biar tidak kepotong)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'List Harga $komoditas',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // izinkan 2 baris agar aman
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Indonesia',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Tombol Input Harga di kanan
              TextButton(
                onPressed: onTapInputHarga,
                style: TextButton.styleFrom(
                  foregroundColor: _linkColor, // warna teks & splash
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'MAU JUALAN?',
                  style: TextStyle(
                    fontSize: 12,
                    color: _linkColor, // pastikan tetap biru
                    decorationThickness: 1.4,
                    decorationColor: _linkColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ===== Baris 2: Toggle View + Sort (kiri) =====
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ViewToggleButton(
                      icon: Icons.view_list,
                      isActive: !isDetailView,
                      onTap: onTapListView,
                    ),
                    _ViewToggleButton(
                      icon: Icons.view_module,
                      isActive: isDetailView,
                      onTap: onTapDetailView,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _SortChip(label: sortLabel, onTap: onTapSort),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF638ECB) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sort, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
