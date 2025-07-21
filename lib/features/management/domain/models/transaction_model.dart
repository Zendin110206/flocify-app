// lib/features/management/domain/models/transaction_model.dart

import 'package:flutter/material.dart';

// Enum untuk mendefinisikan jenis transaksi secara type-safe.
enum TransactionType { pemasukan, pengeluaran }

class Transaction {
  final String id;
  final TransactionType type;
  final String category;
  final String pondName;
  final double amount;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final DateTime date;
  final String? description;
  final IconData icon;
  final Color color;
  final String status;
  final String? partner; // Bisa pembeli atau supplier

  const Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.pondName,
    required this.amount,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.date,
    this.description,
    required this.icon,
    required this.color,
    required this.status,
    this.partner,
  });
}
