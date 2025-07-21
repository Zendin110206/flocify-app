// lib/features/management/domain/models/financial_summary_model.dart

// Cetakan untuk data ringkasan keuangan yang akan ditampilkan di tab "Ringkasan".
class FinancialSummary {
  final double totalIncome;
  final double totalExpense;
  final double netProfit;
  final double profitMargin;
  final double returnOnInvestment;
  final int transactionCount;
  final int activePonds;
  final double totalProductionInKg;
  final double averageFCR;

  const FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netProfit,
    required this.profitMargin,
    required this.returnOnInvestment,
    required this.transactionCount,
    required this.activePonds,
    required this.totalProductionInKg,
    required this.averageFCR,
  });
}
