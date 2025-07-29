// Path: lib/features/pond_creation/presentation/widgets/step_2_pool_type.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/create_pond_provider.dart';

// Data dummy untuk jenis kolam.
final _poolTypes = [
  {
    'name': 'Kolam Terpal',
    'icon': '🟦',
    'description': 'Fleksibel dan mudah dalam perawatan',
    'pros': ['Biaya rendah', 'Mudah dipindah', 'Kontrol pH baik'],
  },
  {
    'name': 'Kolam Beton',
    'icon': '🧱',
    'description': 'Permanen dengan daya tahan tinggi',
    'pros': ['Tahan lama', 'Stabil', 'Kapasitas besar'],
  },
  {
    'name': 'Kolam Tanah',
    'icon': '🌱',
    'description': 'Tradisional dengan biaya minimal',
    'pros': ['Biaya murah', 'Natural', 'Cocok skala besar'],
  },
];

class Step2PoolType extends ConsumerWidget {
  const Step2PoolType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(createPondProvider);
    final wizardController = ref.read(createPondProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Pilih Jenis Kolam',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih jenis kolam yang sesuai dengan kondisi lahan dan modal Anda.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        ..._poolTypes.map((poolType) {
          final isSelected = wizardState.selectedPoolType == poolType['name'];
          return _PoolTypeCard(
            name: poolType['name'] as String,
            icon: poolType['icon'] as String,
            description: poolType['description'] as String,
            pros: poolType['pros'] as List<String>,
            isSelected: isSelected,
            onTap: () =>
                wizardController.selectPoolType(poolType['name'] as String),
          );
        }).toList(),
      ],
    );
  }
}

// Widget privat untuk kartu pilihan jenis kolam
class _PoolTypeCard extends StatelessWidget {
  final String name;
  final String icon;
  final String description;
  final List<String> pros;
  final bool isSelected;
  final VoidCallback onTap;

  const _PoolTypeCard({
    required this.name,
    required this.icon,
    required this.description,
    required this.pros,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey[200]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          // Gunakan Stack untuk menumpuk tanda centang di atas konten
          child: Stack(
            children: [
              // Lapisan Bawah: Semua konten kartu
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor.withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? primaryColor
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Beri ruang kosong selebar tanda centang agar teks tidak tertutup
                        const SizedBox(width: 24),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 66.0),
                      // Kembali gunakan Wrap untuk layout chip yang fleksibel dan anti-overflow
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: pros
                            .map((pro) => _buildProChip(pro))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Lapisan Atas: Tanda centang (hanya jika terpilih)
              if (isSelected)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Icon(
                    Icons.check_circle,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat chip keunggulan
  Widget _buildProChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD1FAE5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF065F46),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
