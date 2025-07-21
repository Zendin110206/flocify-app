// lib/features/management/data/repositories/summary_repository.dart

import 'package:flutter/material.dart';
import '../../domain/models/financial_summary_model.dart';
import '../../domain/models/transaction_model.dart';

// ===================================================================
// KONTRAK & IMPLEMENTASI UNTUK RINGKASAN KEUANGAN
// ===================================================================

abstract class FinancialSummaryRepository {
  Future<FinancialSummary> getFinancialSummary({required String period});
}

class FakeFinancialSummaryRepository implements FinancialSummaryRepository {
  // Data dummy dari kode lama
  final Map<String, FinancialSummary> _dummyData = {
    'Bulan Ini': const FinancialSummary(
      totalIncome: 31850000,
      totalExpense: 18950000,
      netProfit: 12900000,
      profitMargin: 40.5,
      returnOnInvestment: 68.1,
      transactionCount: 45,
      activePonds: 5,
      totalProductionInKg: 1850,
      averageFCR: 1.32,
    ),
    'Minggu Ini': const FinancialSummary(
      totalIncome: 8500000,
      totalExpense: 4200000,
      netProfit: 4300000,
      profitMargin: 50.6,
      returnOnInvestment: 102.4,
      transactionCount: 12,
      activePonds: 5,
      totalProductionInKg: 485,
      averageFCR: 1.28,
    ),
    'Hari Ini': const FinancialSummary(
      totalIncome: 2200000,
      totalExpense: 850000,
      netProfit: 1350000,
      profitMargin: 61.4,
      returnOnInvestment: 158.8,
      transactionCount: 3,
      activePonds: 5,
      totalProductionInKg: 125,
      averageFCR: 1.25,
    ),
    // Data untuk periode lain bisa ditambahkan di sini
  };

  @override
  Future<FinancialSummary> getFinancialSummary({required String period}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Mengembalikan data sesuai periode, atau default 'Bulan Ini' jika tidak ditemukan.
    return _dummyData[period] ?? _dummyData['Bulan Ini']!;
  }
}

// ===================================================================
// KONTRAK & IMPLEMENTASI UNTUK TRANSAKSI
// ===================================================================

abstract class TransactionRepository {
  Future<List<Transaction>> getRecentTransactions({int count = 5});
  Future<List<Transaction>> getAllTransactions();
}

class FakeTransactionRepository implements TransactionRepository {
  // Data dummy dari kode lama, diubah menjadi model Transaction
  final List<Transaction> _dummyTransactions = [
    Transaction(
      id: 'TRX001',
      type: TransactionType.pemasukan,
      category: 'Penjualan Lele',
      pondName: 'Kolam A1',
      amount: 6500000,
      quantity: 500,
      unit: 'kg',
      pricePerUnit: 13000,
      date: DateTime.parse('2025-07-15T08:30:00'),
      partner: 'Pasar Ikan Segar',
      description: 'Penjualan lele ukuran konsumsi',
      icon: Icons.sell,
      color: const Color(0xFF4CAF50),
      status: 'Selesai',
    ),
    Transaction(
      id: 'TRX002',
      type: TransactionType.pengeluaran,
      category: 'Pakan',
      pondName: 'Kolam A1',
      amount: 2850000,
      quantity: 150,
      unit: 'kg',
      pricePerUnit: 19000,
      date: DateTime.parse('2025-07-14T14:15:00'),
      partner: 'Toko Pakan Jaya',
      description: 'Pakan lele premium PF-1000',
      icon: Icons.restaurant,
      color: const Color(0xFFFF9800),
      status: 'Selesai',
    ),
    Transaction(
      id: 'TRX003',
      type: TransactionType.pemasukan,
      category: 'Penjualan Nila',
      pondName: 'Kolam A2',
      amount: 4200000,
      quantity: 300,
      unit: 'kg',
      pricePerUnit: 14000,
      date: DateTime.parse('2025-07-13T09:45:00'),
      partner: 'Restoran Seafood',
      description: 'Penjualan nila segar',
      icon: Icons.sell,
      color: const Color(0xFF2196F3),
      status: 'Selesai',
    ),
    Transaction(
      id: 'TRX004',
      type: TransactionType.pengeluaran,
      category: 'Bibit',
      pondName: 'Kolam C1',
      amount: 1800000,
      quantity: 7000,
      unit: 'ekor',
      pricePerUnit: 257,
      date: DateTime.parse('2025-07-12T07:00:00'),
      partner: 'Pembenihan Maju',
      description: 'Bibit lele sangkuriang',
      icon: Icons.pets,
      color: const Color(0xFF9C27B0),
      status: 'Selesai',
    ),
    Transaction(
      id: 'TRX005',
      type: TransactionType.pengeluaran,
      category: 'Obat & Vitamin',
      pondName: 'Kolam B1',
      amount: 450000,
      quantity: 2,
      unit: 'paket',
      pricePerUnit: 225000,
      date: DateTime.parse('2025-07-11T16:20:00'),
      partner: 'Apotek Ikan Sehat',
      description: 'Vitamin dan probiotik',
      icon: Icons.medical_services,
      color: const Color(0xFFE91E63),
      status: 'Selesai',
    ),
    Transaction(
      id: 'TRX006',
      type: TransactionType.pengeluaran,
      category: 'Listrik & Air',
      pondName: 'Semua Kolam',
      amount: 850000,
      quantity: 1,
      unit: 'bulan',
      pricePerUnit: 850000,
      date: DateTime.parse('2025-07-10T10:00:00'),
      partner: 'PLN & PDAM',
      description: 'Tagihan listrik dan air',
      icon: Icons.electrical_services,
      color: const Color(0xFF607D8B),
      status: 'Selesai',
    ),
  ];

  @override
  Future<List<Transaction>> getAllTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dummyTransactions;
  }

  @override
  Future<List<Transaction>> getRecentTransactions({int count = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dummyTransactions.take(count).toList();
  }
}
