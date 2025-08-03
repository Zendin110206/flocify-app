// lib/features/home/presentation/widgets/report_overview_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/home_pond_status_model.dart';
import '../providers/home_providers.dart';

class ReportOverviewSection extends ConsumerWidget {
  const ReportOverviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredPonds = ref.watch(filteredPondStatusProvider);
    final commodities = ref.watch(commodityListProvider);
    final selectedCommodity = ref.watch(selectedCommodityProvider);

    return Container(
      margin: const EdgeInsets.only(top: 24, left: 18, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Overview',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          _buildCommodityFilter(commodities, selectedCommodity, ref),
          const SizedBox(height: 10),
          if (filteredPonds.isEmpty)
            Container(
              height: 207,
              alignment: Alignment.center,
              child: const Text('Tidak ada data untuk komoditas ini.'),
            )
          else
            _CarouselContainer(ponds: filteredPonds),
        ],
      ),
    );
  }

  Widget _buildCommodityFilter(
    List<String> commodities,
    String selectedCommodity,
    WidgetRef ref,
  ) {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(top: 16, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: commodities.length,
        itemBuilder: (context, index) {
          final commodity = commodities[index];
          return GestureDetector(
            onTap: () {
              ref.read(selectedCommodityProvider.notifier).state = commodity;
              ref.read(carouselIndexProvider.notifier).state = 0;
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: commodity == selectedCommodity
                    ? const Color(0xFF638ECB)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: commodity == selectedCommodity
                      ? Colors.transparent
                      : Colors.grey.shade300,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                commodity,
                style: TextStyle(
                  color: commodity == selectedCommodity
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CarouselContainer extends ConsumerWidget {
  final List<HomePondStatus> ponds;
  const _CarouselContainer({required this.ponds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = PageController();
    final totalPages = (ponds.length / 4).ceil();
    final screenWidth = MediaQuery.of(context).size.width;

    // INI TUH EMANG GPT KARENA AKU KURANG MEMAHAMI BAGAIMANA RESPONSIF SUATU LAYAR BEKERJA
    /// Kalau kita pakai padding 16 + 12 + 16 = 44 di kanan-kiri,
    /// maka lebar tiap kartu ≈ (screenWidth - 44) / 2.
    /// Tinggi kontainer = 2 baris kartu + padding-spacing internal (≈ 60 px).
    final cardSide = (screenWidth - 44) / 2;
    final containerHeight = // ①
        ((cardSide * 2) + 40.0) //   ← seluruh hasil dijumlah dulu
            .clamp(170.0, 210.0); // ② lalu di-clamp
    // Listener untuk sinkronisasi PageController dengan StateProvider
    pageController.addListener(() {
      if (pageController.page?.round() != ref.read(carouselIndexProvider)) {
        ref.read(carouselIndexProvider.notifier).state = pageController.page!
            .round();
      }
    });

    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF8AAEE0),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: totalPages,
              itemBuilder: (context, pageIndex) =>
                  _buildCarouselPage(ponds, pageIndex),
            ),
          ),
          if (totalPages > 1) _buildCarouselIndicators(totalPages),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildCarouselIndicators(int totalPages) {
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = ref.watch(carouselIndexProvider);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalPages, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentIndex == index ? 8.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Colors.white
                    : Colors.white.withAlpha((0.5 * 255).round()),
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildCarouselPage(List<HomePondStatus> data, int pageIndex) {
    final startIndex = pageIndex * 4;
    final endIndex = (startIndex + 4).clamp(0, data.length);
    final pageData = data.sublist(startIndex, endIndex);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                if (pageData.isNotEmpty) _buildPondCard(pageData[0]),
                if (pageData.length > 1) const SizedBox(width: 12),
                if (pageData.length > 1)
                  _buildPondCard(pageData[1])
                else
                  const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                if (pageData.length > 2) _buildPondCard(pageData[2]),
                if (pageData.length > 3) const SizedBox(width: 12),
                if (pageData.length > 3)
                  _buildPondCard(pageData[3])
                else
                  const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPondCard(HomePondStatus pond) {
    final color = _getStatusColor(pond.status);
    final icon = _getStatusIcon(pond.status);
    String display = pond.descriptions.length > 1
        ? '${pond.descriptions.length} Peringatan'
        : pond.descriptions.first;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pond.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    display,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, height: 1.3),
                  ),
                ),
              ],
            ),
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(PondStatus status) {
    switch (status) {
      case PondStatus.critical:
        return Colors.red.shade600;
      case PondStatus.warning:
        return Colors.orange.shade600;
      case PondStatus.normal:
        return Colors.green.shade600;
    }
  }

  IconData _getStatusIcon(PondStatus status) {
    switch (status) {
      case PondStatus.critical:
        return Icons.error;
      case PondStatus.warning:
        return Icons.warning;
      case PondStatus.normal:
        return Icons.check_circle;
    }
  }
}
