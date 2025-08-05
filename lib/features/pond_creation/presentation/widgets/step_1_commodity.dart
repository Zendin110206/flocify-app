// Path: lib/features/asset_management/tab/pond_creation/presentation/widgets/step_1_commodity.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/create_pond_provider.dart';

// Data dummy untuk komoditas. Nanti bisa dipindah ke repository.
final _commodities = [
  {
    'name': 'Lele',
    'icon': '🐟',
    'description': 'Ikan air tawar populer dengan pertumbuhan cepat',
  },
  {
    'name': 'Nila',
    'icon': '🐠',
    'description': 'Ikan konsumsi dengan daya tahan tinggi',
  },
  {
    'name': 'Gurame',
    'icon': '🐡',
    'description': 'Ikan premium dengan nilai jual tinggi',
  },
  {
    'name': 'Udang Vaname',
    'icon': '🦐',
    'description': 'Komoditas ekspor unggulan yang sensitif',
  },
];

class Step1Commodity extends ConsumerWidget {
  const Step1Commodity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Baca state saat ini dan controller dari provider
    final wizardState = ref.watch(createPondProvider);
    final wizardController = ref.read(createPondProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Pilih Komoditas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih jenis ikan atau udang yang akan Anda budidayakan.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        // Gunakan .map untuk mengubah data list menjadi list widget
        ..._commodities.map((commodity) {
          final isSelected = wizardState.selectedCommodity == commodity['name'];
          return _CommodityCard(
            name: commodity['name']!,
            // Ganti 'icon' menjadi image path
            // imagePath: commodity['icon']!,
            icon: commodity['icon']!, // Sementara pakai teks dulu
            description: commodity['description']!,
            isSelected: isSelected,
            onTap: () => wizardController.selectCommodity(commodity['name']!),
          );
        }),
      ],
    );
  }
}

// Widget privat untuk kartu pilihan komoditas
class _CommodityCard extends StatelessWidget {
  final String name;
  final String icon; // Ganti tipe data ke String
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _CommodityCard({
    required this.name,
    required this.icon,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withAlpha((0.05 * 255).round())
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey[200]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withAlpha((0.04 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withAlpha((0.1 * 255).round())
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  // Ganti Text dengan Image.asset
                  // child: Image.asset(imagePath, width: 32, height: 32),
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
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
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isSelected)
                Icon(Icons.check_circle, color: primaryColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
