// lib/features/management/presentation/providers/summary_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/summary_repository.dart';
import '../../domain/models/financial_summary_model.dart';
import '../../domain/models/transaction_model.dart';
// Impor Use Case yang baru kita buat
import '../../domain/usecases/calculate_transaction_summary_usecase.dart';


// ===================================================================
// PROVIDER UNTUK REPOSITORY
// ===================================================================

final financialSummaryRepositoryProvider = Provider<FinancialSummaryRepository>(
  (ref) {
    return FakeFinancialSummaryRepository();
  },
);

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return FakeTransactionRepository();
});

// ===================================================================
// PROVIDER UNTUK DATA MENTAH
// ===================================================================

final financialSummaryProvider = FutureProvider.autoDispose
    .family<FinancialSummary, String>((ref, period) {
  final repository = ref.watch(financialSummaryRepositoryProvider);
  return repository.getFinancialSummary(period: period);
});

final recentTransactionsProvider =
    FutureProvider.autoDispose<List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getRecentTransactions();
});

final allTransactionsProvider = FutureProvider.autoDispose<List<Transaction>>((
  ref,
) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getAllTransactions();
});


// ===================================================================
// PROVIDER UNTUK USE CASE ('KOKI')
// ===================================================================

final calculateTransactionSummaryUseCaseProvider =
    Provider((ref) => CalculateTransactionSummaryUseCase());


// ===================================================================
// PROVIDER UNTUK DATA OLAHAN ('HIDANGAN')
// ===================================================================

// Provider ini sekarang sudah direfaktor!
final transactionSummaryProvider =
    Provider.autoDispose<({double income, double expense})>((ref) {
  // 1. Ambil data mentah (bahan-bahan)
  final transactions =
      ref.watch(allTransactionsProvider).asData?.value ?? [];

  // 2. Ambil 'Koki'-nya
  final useCase = ref.read(calculateTransactionSummaryUseCaseProvider);

  // 3. Minta 'Koki' untuk memasak dan kembalikan hasilnya
  return useCase.call(transactions: transactions);
});