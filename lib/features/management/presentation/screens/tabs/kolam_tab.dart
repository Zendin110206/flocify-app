// lib/features/management/presentation/tabs/kolam_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/pond_model.dart';
import '../../providers/pond_providers.dart';
import 'package:proyek_flocify/core/utils/formatter.dart';


// Widget utama untuk konten Tab Kolam
class KolamTab extends StatelessWidget {
  const KolamTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // FUNGSI FUNGSI PANGGILAN
        _SectionTitle(title: 'Ringkasan Performa'),

        _PondSummaryCards(),
        SizedBox(height: 20), // <-- Tambahkan spasi vertikal sebesar 20 pixel

        _SectionTitle(title: 'Detail Kolam'),

        _FilterSection(),

        _PondList(),
      ],
    );
  }
}

// Widget untuk judul section
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF395886), // Warna biru tua agar konsisten
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// WIDGET BARU: KARTU-KARTU RINGKASAN KOLAM
// ===================================================================
class _PondSummaryCards extends ConsumerWidget {
  const _PondSummaryCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Awasi provider ringkasan untuk mendapatkan data yang sudah dihitung.
    final summary = ref.watch(pondSummaryProvider);
    final formater = NumberFormat.decimalPattern('id_ID');

    // Container pembungkus utama dengan gradien biru.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8AAEE0), Color(0xFF638ECB)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.1).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _PondSummaryCard(
                  title: 'Kolam Aktif',
                  value: '${summary.activePonds}/${summary.totalPonds}',
                  icon: Icons.water,
                  color: const Color(0xFF2196F3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PondSummaryCard(
                  title: 'Total Populasi',
                  value: formater.format(summary.totalPopulation),
                  icon: FontAwesomeIcons.fish,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PondSummaryCard(
                  title: 'ROI Rata-rata',
                  value: '${summary.averageROI.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: const Color(0xFFFF9800),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PondSummaryCard(
                  title: 'Siap Panen',
                  value: '${summary.readyToHarvest} Kolam',
                  icon: Icons.agriculture,
                  color: const Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget pembantu untuk satu kartu ringkasan.
class _PondSummaryCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const _PondSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// ===================================================================
// WIDGET-WIDGET INTERNAL UNTUK TAB KOLAM
// ===================================================================

class _FilterSection extends ConsumerWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedPeriodFilterProvider);
    final selectedPond = ref.watch(selectedPondFilterProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: _filterButton(
              label: selectedPeriod,
              onTap: () => _showPeriodPicker(context, ref),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _filterButton(
              label: selectedPond,
              onTap: () => _showPondPicker(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}

class _PondList extends ConsumerWidget {
  const _PondList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPonds = ref.watch(pondListProvider);
    final filteredPonds = ref.watch(filteredPondListProvider);

    return asyncPonds.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 40, bottom: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 40),
        child: Center(child: Text('Error: $error')),
      ),
      data: (_) {
        if (filteredPonds.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.water,
                    size: 48,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Kolam tidak ditemukan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coba gunakan filter lain atau reset filter untuk melihat semua kolam.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  _ResetFilterButton(ref: ref), // <- baru
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredPonds.length,
          itemBuilder: (context, index) {
            final pond = filteredPonds[index];
            return _PondCard(pond: pond);
          },
        );
      },
    );
  }
}

class _ResetFilterButton extends StatelessWidget {
  final WidgetRef ref;
  const _ResetFilterButton({required this.ref});

  void _reset() {
    ref.read(selectedPondFilterProvider.notifier).state = 'Semua Kolam';
    ref.read(selectedPeriodFilterProvider.notifier).state = 'Bulan Ini';
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Semantics(
      button: true,
      label: 'Reset semua filter kolam dan periode',
      child: Tooltip(
        message: 'Kembalikan filter ke default',
        child: FilledButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.restart_alt_rounded, size: 20),
          label: const Text('Reset Filter'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: primary,
            foregroundColor: onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2, // cukup naik sedikit, jangan terlalu berat
          ),
        ),
      ),
    );
  }
}

class _PondCard extends StatelessWidget {
  final Pond pond;
  const _PondCard({required this.pond});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pond.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${pond.fishType} • ${pond.size}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              _StatusChip(status: pond.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MetricItem(
                label: 'Populasi',
                value: '${formatNumber(pond.population)} ekor',
              ),
              _MetricItem(
                label: 'Umur',
                value: '${pond.age} / ${pond.harvestTarget} hari',
              ),
              _MetricItem(
                label: 'Berat Rata-rata',
                value: '${pond.avgWeight} gr',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MetricItem(label: 'FCR', value: pond.feedConversion.toString()),
              _MetricItem(label: 'Mortalitas', value: '${pond.mortality}%'),
              _MetricItem(
                label: 'ROI',
                value: '${pond.roi}%',
                valueColor: const Color(0xFF4CAF50),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Keuntungan',
                  value: formatCurrency(pond.profit),
                  valueColor: const Color(0xFF4CAF50),
                ),
                const SizedBox(height: 4),
                _SummaryRow(
                  label: 'Est. Panen',
                  value: DateFormat(
                    'd MMM yyyy',
                    'id_ID',
                  ).format(pond.estimatedHarvest),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}

Widget _filterButton({required String label, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ],
      ),
    ),
  );
}

void _showPeriodPicker(BuildContext context, WidgetRef ref) {
  final periods = <String>[
    'Bulan Ini',
    'Minggu Ini',
    'Hari Ini',
    '3 Bulan',
    '6 Bulan',
    '1 Tahun',
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: (ctx, scrollCtrl) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.08 * 255).round()),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih Periode',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tampilkan data sesuai rentang waktu',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    separatorBuilder: (_, __) =>
                        Divider(color: Colors.grey[200]),
                    itemCount: periods.length,
                    itemBuilder: (ctx, i) {
                      final label = periods[i];
                      final selected =
                          ref.watch(selectedPeriodFilterProvider) == label;
                      return Material(
                        color: selected
                            ? Theme.of(
                                context,
                              ).primaryColor.withAlpha((0.1 * 255).round())
                            : Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref
                                    .read(selectedPeriodFilterProvider.notifier)
                                    .state =
                                label;
                            Navigator.of(ctx).pop();
                          },
                          splashColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha((0.2 * 255).round()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 20,
                                  color: selected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[700],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: selected
                                          ? Theme.of(context).primaryColor
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    ),
  );
}

void _showPondPicker(BuildContext context, WidgetRef ref) {
  final ponds = ref.read(pondNameListProvider);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: (ctx, scrollCtrl) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.08 * 255).round()),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih Kolam',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tampilkan data untuk kolam terpilih',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    separatorBuilder: (_, __) =>
                        Divider(color: Colors.grey[200]),
                    itemCount: ponds.length,
                    itemBuilder: (ctx, i) {
                      final label = ponds[i];
                      final selected =
                          ref.watch(selectedPondFilterProvider) == label;
                      return Material(
                        color: selected
                            ? Theme.of(
                                context,
                              ).primaryColor.withAlpha((0.1 * 255).round())
                            : Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref
                                    .read(selectedPondFilterProvider.notifier)
                                    .state =
                                label;
                            Navigator.of(ctx).pop();
                          },
                          splashColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha((0.2 * 255).round()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.water,
                                  size: 20,
                                  color: selected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[700],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: selected
                                          ? Theme.of(context).primaryColor
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'aktif':
      return const Color(0xFF4CAF50);
    case 'baru':
      return const Color(0xFF2196F3);
    default:
      return Colors.grey;
  }
}
