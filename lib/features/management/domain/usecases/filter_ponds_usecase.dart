// lib/features/management/domain/usecases/filter_ponds_usecase.dart

import '../models/pond_model.dart';

class FilterPondsUseCase {
  List<Pond> call({
    required List<Pond> allPonds,
    required String selectedPond,
    required String selectedPeriod,
  }) {
    if (allPonds.isEmpty) return [];

    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    // --- Semua logika penentuan tanggal ada di sini ---
    switch (selectedPeriod) {
      case 'Hari Ini':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'Minggu Ini':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = startDate.add(const Duration(days: 7));
        break;
      case 'Bulan Ini':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
        break;
      case '3 Bulan':
        startDate = DateTime(now.year, now.month - 2, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
        break;
      case '6 Bulan':
        startDate = DateTime(now.year, now.month - 5, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
        break;
      case '1 Tahun':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year + 1, 1, 1);
        break;
      default:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
    }

    List<Pond> filteredList = allPonds;

    // --- Logika filter nama ---
    if (selectedPond != 'Semua Kolam') {
      filteredList = filteredList
          .where((pond) => pond.name == selectedPond)
          .toList();
    }

    // --- Logika filter tanggal ---
    filteredList = filteredList.where((pond) {
      return pond.estimatedHarvest.isAfter(startDate) &&
          pond.estimatedHarvest.isBefore(endDate);
    }).toList();

    return filteredList;
  }
}