// lib/features/management/domain/usecases/get_pond_summary_usecase.dart

import '../models/pond_model.dart';
import '../models/pond_summary_model.dart';

// Kelas ini hanya punya satu tugas: menghitung ringkasan kolam.
class GetPondSummaryUseCase {
  
  // Metode 'call' membuatnya bisa dipanggil seperti fungsi biasa.
  PondSummary call({required List<Pond> ponds}) {
    if (ponds.isEmpty) {
      return const PondSummary(
        activePonds: 0,
        totalPonds: 0,
        totalPopulation: 0,
        averageROI: 0,
        readyToHarvest: 0,
      );
    }

    // --- Semua logika bisnis murni ada di sini ---
    final activePonds = ponds
        .where((p) => p.status.toLowerCase() == 'aktif')
        .length;
    final totalPonds = ponds.length;
    final totalPopulation = ponds.fold<int>(0, (sum, p) => sum + p.population);
    final totalROI = ponds.fold<double>(0.0, (sum, p) => sum + p.roi);
    final averageROI = totalPonds > 0 ? totalROI / totalPonds : 0.0;
    final readyToHarvest = ponds.where((p) => p.age >= p.harvestTarget).length;

    return PondSummary(
      activePonds: activePonds,
      totalPonds: totalPonds,
      totalPopulation: totalPopulation,
      averageROI: averageROI,
      readyToHarvest: readyToHarvest,
    );
  }
}