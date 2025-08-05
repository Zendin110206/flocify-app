// Path: lib/features/asset_management/tab/pond_creation/presentation/widgets/step_3_cultivation_plan.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/create_pond_provider.dart';

// Data dummy untuk rencana budidaya.
final _cultivationPlans = [
  {
    'name': 'Intensif',
    'duration': '3-4 bulan',
    'density': 'Tinggi (100-150 ekor/m²)',
    'description':
        'Padat tebar tinggi dengan monitoring ketat untuk hasil maksimal.',
    'features': ['Feeding otomatis', 'Monitoring 24/7', 'Hasil panen tinggi'],
  },
  {
    'name': 'Semi-Intensif',
    'duration': '4-5 bulan',
    'density': 'Sedang (50-100 ekor/m²)',
    'description': 'Seimbang antara produktivitas, biaya, dan risiko.',
    'features': ['Feeding terjadwal', 'Monitoring rutin', 'ROI optimal'],
  },
  {
    'name': 'Ekstensif',
    'duration': '5-6 bulan',
    'density': 'Rendah (20-50 ekor/m²)',
    'description': 'Sistem alami dengan input dan biaya operasional minimal.',
    'features': ['Feeding manual', 'Monitoring berkala', 'Biaya rendah'],
  },
];

class Step3CultivationPlan extends ConsumerWidget {
  const Step3CultivationPlan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(createPondProvider);
    final wizardController = ref.read(createPondProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Pilih Perencanaan Budidaya',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih intensitas budidaya yang sesuai dengan target dan sumber daya Anda.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        ..._cultivationPlans.map((plan) {
          final isSelected = wizardState.selectedPlan == plan['name'];
          return _PlanCard(
            name: plan['name'] as String,
            description: plan['description'] as String,
            duration: plan['duration'] as String,
            density: plan['density'] as String,
            features: plan['features'] as List<String>,
            isSelected: isSelected,
            onTap: () => wizardController.selectPlan(plan['name'] as String),
          );
        }),
      ],
    );
  }
}

// Widget privat untuk kartu pilihan rencana
class _PlanCard extends StatelessWidget {
  final String name;
  final String description;
  final String duration;
  final String density;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.name,
    required this.description,
    required this.duration,
    required this.density,
    required this.features,
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? primaryColor
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Detail Durasi & Kepadatan
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem('Estimasi Durasi', duration),
                      ),
                      Expanded(
                        child: _buildDetailItem('Kepadatan Tebar', density),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Fitur Utama
                  Text(
                    'Fitur Utama',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...features.map((feature) => _buildFeatureItem(feature)),
                ],
              ),
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
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

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(Icons.check, size: 16, color: Colors.green[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
