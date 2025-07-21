// lib/features/forum/presentation/widgets/commodity_filter_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/forum_providers.dart';
import '../../domain/models/commodity.dart';

/// Section for displaying commodity filters in a horizontal list.
class CommodityFilterSection extends ConsumerWidget {
  const CommodityFilterSection({super.key});

  // lib/features/forum/presentation/widgets/commodity_filter_section.dart

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Ambil data dari provider. Nama variabelnya kita beri '...Async'
    //    untuk menandakan ini adalah state asinkron (loading/error/data).
    final commoditiesAsync = ref.watch(commoditiesProvider);
    final selectedFilter = ref.watch(forumFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            'Komoditas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // 2. Gunakan .when() untuk menangani semua state.
        commoditiesAsync.when(
          // Saat data sedang dimuat
          loading: () => const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          // Jika terjadi error
          error: (err, stack) => SizedBox(
            height: 120,
            child: Center(child: Text('Gagal memuat komoditas')),
          ),
          // Saat data berhasil didapat
          data: (commodities) => SizedBox(
            // 'commodities' sekarang adalah List<Commodity>
            height: 120,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              // 3. Gunakan data 'commodities' yang didapat dari provider
              itemCount: commodities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final commodity = commodities[index];
                return CommodityCard(
                  commodity: commodity,
                  isSelected: selectedFilter == commodity.name,
                  onTap: () {
                    ref.read(forumFilterProvider.notifier).state =
                        commodity.name;
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// A card widget for a single commodity filter.
class CommodityCard extends StatelessWidget {
  final Commodity commodity;
  final bool isSelected;
  final VoidCallback onTap;

  const CommodityCard({
    super.key,
    required this.commodity,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeGradient = LinearGradient(
      colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    const inactiveGradient = LinearGradient(
      colors: [Color(0xFF4A6C9B), Color(0xFF3A506B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isSelected ? activeGradient : inactiveGradient,
            border: isSelected
                ? Border.all(color: Colors.white.withAlpha(230), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.blue.withAlpha(77)
                    : Colors.black.withAlpha(51),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  commodity.iconData,
                  size: 100,
                  color: Colors.white.withAlpha(38),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      commodity.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                      ),
                    ),
                    Text(
                      '${commodity.postCount} Post',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
