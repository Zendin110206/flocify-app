// lib/core/utils/formatter.dart
import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final format = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return format.format(amount);
}

// Tambahkan juga format number agar terpusat
String formatNumber(num number) {
  final format = NumberFormat.decimalPattern('id_ID');
  return format.format(number);
}