// lib/features/management/presentation/tabs/analisis_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/models/pond_model.dart';
import '../providers/pond_providers.dart';
import 'package:proyek_flocify/core/utils/formatter.dart';
import 'package:proyek_flocify/features/management/presentation/widgets/section_header.dart';

// ===================================================================
// WIDGET UTAMA TAB ANALISIS
// ===================================================================
class AnalisisTab extends ConsumerWidget {
  const AnalisisTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Awasi data utama. Kita akan menampilkan skeleton jika data ini masih loading.
    final pondsAsync = ref.watch(pondListProvider);

    return pondsAsync.when(
      loading: () =>
          const _AnalisisTabSkeleton(), // Tampilkan skeleton penuh saat loading
      error: (err, stack) => Center(child: Text("Error memuat data: $err")),
      data: (_) => const SingleChildScrollView(
        // Bungkus dengan SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'Analisis Profitabilitas'),
            _ProfitabilityAnalysisCard(),
            SizedBox(height: 20),
            SectionHeader(title: 'Analisis Efisiensi Pakan'),
            _EfficiencyAnalysisCard(),
            SizedBox(height: 20),
            SectionHeader(title: 'Ranking Performa (ROI)'),
            _PerformanceRanking(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// WIDGET-WIDGET PEMBANTU UNTUK TAB INI
// ===================================================================

class _ProfitabilityAnalysisCard extends ConsumerWidget {
  const _ProfitabilityAnalysisCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(profitabilityAnalysisProvider);

    if (analysis.best == null || analysis.worst == null) {
      return const _AnalysisPlaceholder(
        icon: FontAwesomeIcons.chartPie,
        message: 'Data tidak cukup untuk analisis profitabilitas.',
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildAnalysisItem(
              label: 'Kolam Terbaik',
              pondName: analysis.best!.name,
              value: formatCurrency(analysis.best!.profit),
              valueColor: const Color(0xFF4CAF50),
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[200],
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          Expanded(
            child: _buildAnalysisItem(
              label: 'Perlu Perhatian',
              pondName: analysis.worst!.name,
              value: formatCurrency(analysis.worst!.profit),
              valueColor: const Color(0xFFFF9800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem({
    required String label,
    required String pondName,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          pondName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _EfficiencyAnalysisCard extends ConsumerWidget {
  const _EfficiencyAnalysisCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(efficiencyAnalysisProvider);

    if (analysis.best == null || analysis.worst == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildAnalysisItem(
              label: 'FCR Terbaik',
              pondName: analysis.best!.name,
              value: 'FCR: ${analysis.best!.feedConversion}',
              valueColor: const Color(0xFF4CAF50),
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[200],
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          Expanded(
            child: _buildAnalysisItem(
              label: 'Perlu Perbaikan',
              pondName: analysis.worst!.name,
              value: 'FCR: ${analysis.worst!.feedConversion}',
              valueColor: const Color(0xFFE53E3E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem({
    required String label,
    required String pondName,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          pondName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _PerformanceRanking extends ConsumerWidget {
  const _PerformanceRanking();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankedPonds = ref.watch(performanceRankingProvider);
    if (rankedPonds.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: rankedPonds.length,
      itemBuilder: (context, index) {
        final pond = rankedPonds[index];
        return _RankingCard(pond: pond, rank: index + 1);
      },
    );
  }
}

class _RankingCard extends StatelessWidget {
  final Pond pond;
  final int rank;

  const _RankingCard({required this.pond, required this.rank});

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Emas
      case 2:
        return const Color(0xFFC0C0C0); // Perak
      case 3:
        return const Color(0xFFCD7F32); // Perunggu
      default:
        return Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pond.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${pond.fishType} • ${pond.size}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${pond.roi}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              Text(
                'ROI',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// SKELETON & PLACEHOLDER WIDGETS
// ===================================================================

class _AnalisisTabSkeleton extends StatelessWidget {
  const _AnalisisTabSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Analisis Profitabilitas'),
          _AnalysisCardSkeleton(),
          SizedBox(height: 20),
          SectionHeader(title: 'Analisis Efisiensi Pakan'),
          _AnalysisCardSkeleton(),
          SizedBox(height: 24),
          SectionHeader(title: 'Ranking Performa (ROI)'),
          _RankingListSkeleton(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AnalysisCardSkeleton extends StatelessWidget {
  const _AnalysisCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _buildSkeletonItem()),
          Container(
            width: 1,
            height: 60,
            color: Colors.grey[200],
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          Expanded(child: _buildSkeletonItem()),
        ],
      ),
    );
  }

  Widget _buildSkeletonItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 12, width: 80, color: Colors.grey[200]),
        const SizedBox(height: 8),
        Container(height: 14, width: 100, color: Colors.grey[200]),
        const SizedBox(height: 4),
        Container(height: 13, width: 60, color: Colors.grey[200]),
      ],
    );
  }
}

class _RankingListSkeleton extends StatelessWidget {
  const _RankingListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3, // Tampilkan 3 item skeleton
      itemBuilder: (context, index) => const _RankingCardSkeleton(),
    );
  }
}

class _RankingCardSkeleton extends StatelessWidget {
  const _RankingCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: Colors.grey[200]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 80, color: Colors.grey[200]),
                const SizedBox(height: 4),
                Container(height: 12, width: 120, color: Colors.grey[200]),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(height: 16, width: 40, color: Colors.grey[200]),
              const SizedBox(height: 4),
              Container(height: 11, width: 20, color: Colors.grey[200]),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalysisPlaceholder extends StatelessWidget {
  final IconData icon;
  final String message;
  const _AnalysisPlaceholder({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.grey[400], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
