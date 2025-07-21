// lib/features/management/domain/usecases/calculate_transaction_summary_usecase.dart

import '../models/transaction_model.dart';

class CalculateTransactionSummaryUseCase {
  // Metode 'call' menerima data mentah (daftar transaksi)
  // dan mengembalikan data olahan (ringkasan pemasukan & pengeluaran).
  ({double income, double expense}) call({
    required List<Transaction> transactions,
  }) {
    // Jika tidak ada data, kembalikan nilai nol.
    if (transactions.isEmpty) {
      return (income: 0, expense: 0);
    }

    // --- Semua logika bisnis murni ada di sini ---

    // Hitung total pemasukan.
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.pemasukan)
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    // Hitung total pengeluaran.
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.pengeluaran)
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    return (income: totalIncome, expense: totalExpense);
  }
}