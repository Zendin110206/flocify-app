// lib/features/management/presentation/tabs/transaksi_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/transaction_model.dart';
import '../providers/summary_providers.dart';
import 'package:proyek_flocify/core/utils/formatter.dart';
import 'package:proyek_flocify/features/management/presentation/widgets/section_header.dart';

/// ===============================================================
///  TAB TRANSAKSI
/// ===============================================================
class TransaksiTab extends ConsumerWidget {
  const TransaksiTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Ringkasan Transaksi'),
        _TransactionSummary(),
        SizedBox(height: 20),

        SectionHeader(title: 'Semua Transaksi'),
        _AllTransactionsList(),

        SizedBox(height: 12),
      ],
    );
  }
}

/// ===============================================================
///  RINGKASAN TRANSAKSI (total income/expense)
/// ===============================================================
class _TransactionSummary extends ConsumerWidget {
  const _TransactionSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(transactionSummaryProvider);

    // NOTE: asumsi provider synchronous; kalau AsyncValue => bungkus .when()
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _TransactionSummaryCard(
              title: 'Total Pemasukan',
              amount: summaryAsync.income,
              icon: Icons.trending_up,
              color: const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TransactionSummaryCard(
              title: 'Total Pengeluaran',
              amount: summaryAsync.expense,
              icon: Icons.trending_down,
              color: const Color(0xFFE53E3E),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _TransactionSummaryCard({
    required this.title,
    required this.amount,
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
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatCurrency(amount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
///  LIST SEMUA TRANSAKSI
/// ===============================================================
class _AllTransactionsList extends ConsumerWidget {
  const _AllTransactionsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(allTransactionsProvider);

    return transactionsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) =>
          Center(child: Text('Gagal memuat transaksi: $err')),
      data: (transactions) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return _TransactionCard(transaction: transactions[index]);
          },
        );
      },
    );
  }
}

/// ===============================================================
///  KARTU TRANSAKSI (disamakan dengan RingkasanTab versi terbaru)
/// ===============================================================
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
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
            // leading icon tint
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
            // title + subtitle
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
            // amount + chevron
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

/// ===============================================================
///  DETAIL SHEET TRANSAKSI (adaptif, profesional, ringkas)
/// ===============================================================
void _showTransactionDetailSheet(BuildContext context, Transaction trx) {
  final mq = MediaQuery.of(context);
  final hasPartner = trx.partner != null && trx.partner!.isNotEmpty;
  final hasDesc = trx.description != null && trx.description!.isNotEmpty;

  // kasar: 5 row dasar + conditional
  final estRowCount = 5 + (hasPartner ? 1 : 0) + (hasDesc ? 2 : 0);
  final estContentHeight = 200 + (estRowCount * 32);
  final double maxSheetFrac = estContentHeight / mq.size.height;
  final bool useDraggable = maxSheetFrac > 0.6;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      if (!useDraggable) {
        // konten pendek: tinggi mengikuti isi
        return _TxDetailBody(trx: trx, scrollable: false);
      } else {
        // konten panjang: scrollable
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          builder: (context, scrollCtrl) {
            return _TxDetailBody(
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

/// BODY wrapper (scrollable / non-scrollable)
class _TxDetailBody extends StatelessWidget {
  final Transaction trx;
  final bool scrollable;
  final ScrollController? extScrollController;
  const _TxDetailBody({
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

    final content = _TxDetailContent(trx: trx, amountColor: amountColor);

    final handle = Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha((.30 * 255).round()),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );

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

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [handle, content],
      ),
    );
  }
}

/// CORE content
class _TxDetailContent extends StatelessWidget {
  final Transaction trx;
  final Color amountColor;
  const _TxDetailContent({required this.trx, required this.amountColor});

  static const double _hPad = 24;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = Theme.of(
      context,
    ).colorScheme.onSurface.withAlpha((.6 * 255).round());

    final iconBg = trx.color.withAlpha((.12 * 255).round());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
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
        // Sections
        Padding(
          padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TxSectionLabel('Detail'),
              const SizedBox(height: 4),
              _TxDetailRow('ID Transaksi', trx.id),
              _TxDetailRow('Kolam', trx.pondName),
              _TxDetailRow('Status', trx.status),
              const SizedBox(height: 16),
              _TxSectionLabel('Volume & Pricing'),
              const SizedBox(height: 4),
              _TxDetailRow('Jumlah', '${trx.quantity} ${trx.unit}'),
              _TxDetailRow('Harga Satuan', formatCurrency(trx.pricePerUnit)),
              if (trx.partner != null && trx.partner!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _TxSectionLabel('Partner'),
                const SizedBox(height: 4),
                _TxDetailRow('Partner', trx.partner!),
              ],
              if (trx.description != null && trx.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _TxSectionLabel('Deskripsi'),
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
        // Close
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
              icon: const Icon(Icons.check_rounded),
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

/// Section label
class _TxSectionLabel extends StatelessWidget {
  final String text;
  const _TxSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF395886),
      ),
    );
  }
}

/// Detail row (rapat)
class _TxDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _TxDetailRow(this.label, this.value);

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
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontSize: 14, color: muted)),
          ),
          const SizedBox(width: 12),
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
