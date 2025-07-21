// lib/features/management/presentation/tabs/ringkasan_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../domain/models/financial_summary_model.dart';
import '../providers/pond_providers.dart';
import '../providers/summary_providers.dart';
import '../../domain/models/pond_model.dart';
import '../../domain/models/transaction_model.dart';
import 'package:proyek_flocify/core/utils/formatter.dart';
import 'package:proyek_flocify/features/management/presentation/widgets/section_header.dart';

// ===================================================================
// WIDGET UTAMA TAB RINGKASAN
// ===================================================================
class RingkasanTab extends StatelessWidget {
  const RingkasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN UTAMA: Menghapus 'const' dari Column karena memiliki
    // anak widget yang dinamis (ConsumerWidget).
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul untuk bagian ringkasan keuangan
        SectionHeader(title: 'Ringkasan Keuangan'),
        _FinancialSummaryCard(),

        SizedBox(height: 20), // <-- Tambahkan spasi vertikal sebesar 20 pixel
        // Judul untuk bagian metrik
        SectionHeader(title: 'Metrik Cepat'),
        _QuickMetrics(),

        SizedBox(height: 20), // <-- Tambahkan spasi vertikal sebesar 20 pixel
        SectionHeader(title: 'Kolam Kinerja Terbaik'),
        _TopPerformingPonds(),

        SizedBox(height: 20), // Jarak antar bagian
        _RecentTransactions(),

        // Jarak aman di bagian bawah
        SizedBox(height: 24),
      ],
    );
  }
}

// Header section dengan aksi di kanan (mis: "Lihat Semua").
// Dipakai untuk "Transaksi Terbaru" supaya align kiri = 16 persis seperti SectionHeader.
class _SectionHeaderWithAction extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onAction;

  const _SectionHeaderWithAction({
    required this.title,
    required this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF395886),
    );
    final defaultActionStyle = const TextStyle(
      color: Color(0xFF638ECB),
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pakai Expanded agar judul panjang tidak dorong tombol keluar layar
          Expanded(
            child: Text(
              title,
              style: defaultTitleStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0), // hilangkan padding default
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionText, style: defaultActionStyle),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// WIDGET KARTU RINGKASAN KEUANGAN
// ===================================================================
class _FinancialSummaryCard extends ConsumerWidget {
  const _FinancialSummaryCard();

  static const profitBgStart = Color(0xFF388E3C);
  static const profitBgEnd = Color(0xFF66BB6A);
  static const lossBgStart = Color(0xFFC62828);
  static const lossBgEnd = Color(0xFFEF5350);
  static const tagRadius = 6.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedPeriodFilterProvider);
    final summaryAsync = ref.watch(financialSummaryProvider(selectedPeriod));

    const profitColor = Color(0xFF4CAF50);
    const expenseColor = Color(0xFFE53E3E);

    return summaryAsync.when(
      loading: () => const SizedBox(
        height: 230,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => SizedBox(
        height: 230,
        child: Center(child: Text('Gagal memuat data: $err')),
      ),
      data: (summary) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF8AAEE0),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          foregroundDecoration: BoxDecoration(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryItem(
                    'Pemasukan',
                    summary.totalIncome,
                    Icons.trending_up,
                    profitColor,
                  ),
                  _buildSummaryItem(
                    'Pengeluaran',
                    summary.totalExpense,
                    Icons.trending_down,
                    expenseColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildNetProfitSection(summary),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.withAlpha((0.8 * 255).round()),
                borderRadius: BorderRadius.circular(tagRadius),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            formatCurrency(amount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNetProfitSection(FinancialSummary summary) {
    final isProfit = summary.netProfit >= 0;
    final startColor = isProfit ? profitBgStart : lossBgStart;
    final endColor = isProfit ? profitBgEnd : lossBgEnd;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(60)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keuntungan Bersih',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatCurrency(summary.netProfit),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Tooltip(
                message: 'Margin keuntungan',
                child: _buildTag('Margin ${summary.profitMargin}%'),
              ),
              const SizedBox(height: 6),
              Tooltip(
                message: 'Return on Investment',
                child: _buildTag('ROI ${summary.returnOnInvestment}%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(tagRadius),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ===================================================================
// METRIK CEPAT (Versi Ditingkatkan UI/UX)
// ===================================================================
class _QuickMetrics extends ConsumerWidget {
  const _QuickMetrics();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedPeriodFilterProvider);
    final summaryAsync = ref.watch(financialSummaryProvider(selectedPeriod));

    return summaryAsync.when(
      data: (summary) {
        // Susun data metrik dalam list agar mudah diubah urutannya.
        final metrics = <_MetricData>[
          _MetricData(
            title: 'Transaksi',
            value: formatNumber(summary.transactionCount),
            icon: FontAwesomeIcons.receipt, // ganti biar konsisten FA
            color: const Color(0xFF4CAF50),
            semanticsLabel: 'Jumlah transaksi',
            onTap: () {
              // TODO: navigasi ke halaman transaksi / filter "periode" saat ini
            },
          ),
          _MetricData(
            title: 'Kolam Aktif',
            value: summary.activePonds.toString(),
            icon: FontAwesomeIcons.water,
            color: const Color(0xFF2196F3),
            semanticsLabel: 'Jumlah kolam aktif',
            onTap: () {
              // TODO: navigasi ke daftar kolam
            },
          ),
          _MetricData(
            title: 'Produksi',
            value: formatNumber(summary.totalProductionInKg.toInt()),
            unit: 'kg',
            icon: FontAwesomeIcons.weightScale,
            color: const Color(0xFF9C27B0),
            semanticsLabel: 'Total produksi dalam kilogram',
            onTap: () {
              // TODO: navigasi ke ringkasan produksi
            },
          ),
          _MetricData(
            title: 'FCR Rata-rata',
            value: summary.averageFCR.toStringAsFixed(2),
            icon: Icons.analytics_outlined,
            color: const Color(0xFFFF9800),
            semanticsLabel: 'Feed Conversion Ratio rata-rata',
            onTap: () {
              // TODO: navigasi ke analisis pakan
            },
          ),
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _MetricGrid(metrics: metrics),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: _MetricGridSkeleton(), // shimmer / placeholder
      ),
      error: (err, stack) {
        // Tetap tampilkan banner error ringan agar user tahu
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _MetricErrorBanner(message: 'Gagal memuat metrik: $err'),
              const SizedBox(height: 12),
              const _MetricGridSkeleton(),
            ],
          ),
        );
      },
    );
  }
}

/// Data model internal untuk memudahkan builder grid.
class _MetricData {
  final String title;
  final String value;
  final String? unit;
  final IconData icon;
  final Color color;
  final String semanticsLabel;
  final VoidCallback? onTap;

  _MetricData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.semanticsLabel,
    this.unit,
    this.onTap,
  });
}

/// Grid 2 kolom adaptif (wrap jika lebar sempit — tetap pakai 2 kolom di ponsel).
class _MetricGrid extends StatelessWidget {
  final List<_MetricData> metrics;
  const _MetricGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    const double gap = 12;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika ruang sangat lebar (tablet), bisa 4 dalam 1 baris; kalau tidak, 2x2.
        final isWide = constraints.maxWidth > 480;
        final crossAxisCount = isWide ? 4 : 2;
        final itemWidth =
            (constraints.maxWidth - (gap * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: metrics.map((m) {
            return SizedBox(
              width: itemWidth,
              child: _MetricCard(data: m),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Kartu metrik interaktif.
class _MetricCard extends StatelessWidget {
  final _MetricData data;
  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface.withAlpha(
      (0.7 * 255).round(),
    );

    // Warna latar ikon = tint lembut
    final iconBg = data.color.withAlpha((0.1 * 255).round());

    // Untuk efek hover / pressed
    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _MetricCardContent(
        icon: data.icon,
        iconBg: iconBg,
        iconColor: data.color,
        value: data.value,
        unit: data.unit,
        title: data.title,
        titleColor: onSurface,
      ),
    );

    // Semantics + InkWell wrapper
    return Semantics(
      label: data.semanticsLabel,
      button: data.onTap != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: data.onTap,
          child: card,
        ),
      ),
    );
  }
}

/// Isi kartu terpisah agar bisa dipakai skeleton.
class _MetricCardContent extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String? unit;
  final String title;
  final Color titleColor;

  const _MetricCardContent({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.title,
    required this.titleColor,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // Value + unit: unit kecil & warna lebih redup
    final valueWidget = _MetricValue(value: value, unit: unit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris atas: icon + value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: FaIcon(icon, color: iconColor, size: 20),
            ),
            valueWidget,
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: titleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Widget angka besar + unit kecil.
class _MetricValue extends StatelessWidget {
  final String value;
  final String? unit;
  const _MetricValue({required this.value, this.unit});

  @override
  Widget build(BuildContext context) {
    final text = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: value,
            style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (unit != null) ...[
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(
              text: unit,
              style: DefaultTextStyle.of(context).style.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
              ),
            ),
          ],
        ],
      ),
    );
    return FittedBox(fit: BoxFit.scaleDown, child: text);
  }
}

// ===================================================================
// Skeleton / Placeholder saat loading
// ===================================================================
class _MetricGridSkeleton extends StatelessWidget {
  const _MetricGridSkeleton();

  @override
  Widget build(BuildContext context) {
    // 4 placeholder dummy
    final dummy = List.generate(
      4,
      (_) => _MetricData(
        title: '',
        value: '',
        icon: Icons.circle,
        color: Colors.grey,
        semanticsLabel: 'Loading',
      ),
    );
    return _MetricGrid(metrics: dummy);
  }
}

class _MetricErrorBanner extends StatelessWidget {
  final String message;
  const _MetricErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.error.withAlpha((0.04 * 255).round()),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 12, color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// WIDGET BARU: KOLAM BERKINERJA TERBAIK
// ===================================================================
class _TopPerformingPonds extends ConsumerWidget {
  const _TopPerformingPonds();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPonds = ref.watch(topPerformingPondsProvider);

    return SizedBox(
      height: 150, // Memberi tinggi yang pasti untuk ListView horizontal
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: topPonds.length,
        itemBuilder: (context, index) {
          final pond = topPonds[index];
          // Beri margin kanan untuk semua item kecuali yang terakhir.
          return Padding(
            padding: EdgeInsets.only(
              right: index == topPonds.length - 1 ? 0 : 12,
            ),
            child: _PerformanceCard(pond: pond),
          );
        },
      ),
    );
  }
}

// Widget pembantu untuk satu kartu performa kolam (VERSI BARU)
class _PerformanceCard extends StatelessWidget {
  final Pond pond;
  const _PerformanceCard({required this.pond});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170, // Sedikit lebih lebar untuk mengakomodasi data baru
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bagian Atas: Nama dan Jenis
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pond.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                pond.fishType,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          // PERBAIKAN: Menambahkan metrik ROI dan FCR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniMetric('ROI', '${pond.roi}%'),
              _buildMiniMetric('FCR', pond.feedConversion.toString()),
            ],
          ),

          // Bagian Bawah: Keuntungan
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keuntungan',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
              Text(
                formatCurrency(pond.profit),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget helper kecil untuk metrik di dalam kartu
  Widget _buildMiniMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ===================================================================
// WIDGET: TRANSAKSI TERBARU (VERSI LENGKAP DENGAN DETAIL)
// ===================================================================
class _RecentTransactions extends ConsumerWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeaderWithAction(
          title: 'Transaksi Terbaru',
          actionText: 'Lihat Semua',
          onAction: () {
            ref.read(managementTabProvider.notifier).state = 2;
          },
        ),
        transactionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Gagal memuat transaksi: $err')),
          data: (transactions) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 4),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return _TransactionCard(transaction: transactions[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

// Widget pembantu untuk menampilkan satu kartu transaksi yang detail.
class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.type == TransactionType.pemasukan;
    final amountColor = isIncome
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53E3E);

    return InkWell(
      onTap: () => _showTransactionDetailSheet(context, transaction),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.05).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: transaction.color.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(transaction.icon, color: transaction.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormat.yMMMd('id_ID').format(transaction.date)} • ${transaction.pondName}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${formatCurrency(transaction.amount)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================================
// SMART TRANSACTION DETAIL SHEET (compact / auto)
// ===============================================
void _showTransactionDetailSheet(BuildContext context, Transaction trx) {
  final mq = MediaQuery.of(context);
  // Estimasi tinggi konten pendek (header + ~6 rows + button)
  // Jika konten pendek, kita pakai Intrinsic height di bawah 0.6 high.
  // Kalau panjang, kita fallback ke DraggableScrollableSheet (scroll).
  final bool hasPartner = trx.partner != null && trx.partner!.isNotEmpty;
  final bool hasDesc = trx.description != null && trx.description!.isNotEmpty;

  // Kira-kira jumlah blok
  final estRowCount = 5 + (hasPartner ? 1 : 0) + (hasDesc ? 2 : 0);
  final estContentHeight = 200 + (estRowCount * 32); // perkiraan
  final double maxSheetFrac = estContentHeight / mq.size.height;
  final bool useDraggable = maxSheetFrac > 0.6; // kalau konten tinggi -> scroll

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      if (!useDraggable) {
        // ---- Konten pendek: sheet setinggi isi, tidak perlu DraggableScrollableSheet ----
        return _TransactionDetailBody(trx: trx, scrollable: false);
      } else {
        // ---- Konten panjang: draggable + scrollable ----
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          builder: (context, scrollCtrl) {
            return _TransactionDetailBody(
              trx: trx,
              scrollable: true,
              extScrollController: scrollCtrl,
            );
          },
        );
      }
    },
  );
}

// ---------------------------------------------------------------
// BODY widget yang bisa dipakai scrollable / non-scrollable
// ---------------------------------------------------------------
class _TransactionDetailBody extends StatelessWidget {
  final Transaction trx;
  final bool scrollable;
  final ScrollController? extScrollController;

  const _TransactionDetailBody({
    required this.trx,
    required this.scrollable,
    this.extScrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = trx.type == TransactionType.pemasukan;
    final amountColor = isIncome
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53E3E);

    final content = _TransactionDetailContent(
      trx: trx,
      amountColor: amountColor,
    );

    // drag handle always shown
    final handle = Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha((0.3 * 255).round()),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );

    // If scrollable: wrap in Column + Expanded(ListView)
    if (scrollable) {
      return Column(
        children: [
          handle,
          Expanded(
            child: ListView(
              controller: extScrollController,
              padding: EdgeInsets.zero,
              children: [content],
            ),
          ),
        ],
      );
    }

    // Not scrollable: use SingleChildScrollView w/ IntrinsicHeight so sheet fits content.
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [handle, content],
      ),
    );
  }
}

// ---------------------------------------------------------------
// CORE CONTENT (header + sections + button)
// ---------------------------------------------------------------
class _TransactionDetailContent extends StatelessWidget {
  final Transaction trx;
  final Color amountColor;
  const _TransactionDetailContent({
    required this.trx,
    required this.amountColor,
  });

  static const double _hPad = 24;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = Theme.of(
      context,
    ).colorScheme.onSurface.withAlpha((.6 * 255).round());

    // Header icon container color tinted
    final iconBg = trx.color.withAlpha((0.1 * 255).round());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ----- Header -----
        Padding(
          padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(trx.icon, color: trx.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul + nominal satu baris (wrap -> 2 baris)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          trx.category,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${trx.type == TransactionType.pemasukan ? '+' : '-'}${formatCurrency(trx.amount)}',
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: amountColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(trx.date),
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 0),
        // ----- Sections -----
        Padding(
          padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel('Detail'),
              const SizedBox(height: 4),
              _DetailRow('ID Transaksi', trx.id),
              _DetailRow('Kolam', trx.pondName),
              _DetailRow('Status', trx.status),
              const SizedBox(height: 16),
              _SectionLabel('Volume & Pricing'),
              const SizedBox(height: 4),
              _DetailRow('Jumlah', '${trx.quantity} ${trx.unit}'),
              _DetailRow('Harga Satuan', formatCurrency(trx.pricePerUnit)),
              if (trx.partner != null && trx.partner!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionLabel('Partner'),
                const SizedBox(height: 4),
                _DetailRow('Partner', trx.partner!),
              ],
              if (trx.description != null && trx.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionLabel('Deskripsi'),
                const SizedBox(height: 4),
                Text(
                  trx.description!,
                  style: textTheme.bodyMedium?.copyWith(fontSize: 14),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        // ----- Close button -----
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(
              left: _hPad,
              right: _hPad,
              bottom: 16,
            ),
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check),
              label: const Text('Tutup'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                backgroundColor: const Color(0xFF638ECB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------
// Section label (lebih profesional, sedikit lebih besar & biru)
// ---------------------------------------------------------------
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF395886), // biru brand
      ),
    );
  }
}

// ---------------------------------------------------------------
// Detail row (ritme vertikal rapat)
// ---------------------------------------------------------------
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(
      context,
    ).colorScheme.onSurface.withAlpha((.6 * 255).round());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontSize: 14, color: muted)),
          ),
          const SizedBox(width: 12),
          // value
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
