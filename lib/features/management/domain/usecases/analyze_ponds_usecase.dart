// lib/features/management/domain/usecases/analyze_ponds_usecase.dart

import '../models/pond_model.dart';

class AnalyzePondsUseCase {
  
  // Mengurutkan berdasarkan profit (untuk topPerformingPondsProvider)
  List<Pond> rankByProfit(List<Pond> ponds) {
    if (ponds.isEmpty) return [];
    final sortedPonds = List<Pond>.from(ponds);
    sortedPonds.sort((a, b) => b.profit.compareTo(a.profit));
    return sortedPonds;
  }

  // Mengurutkan berdasarkan ROI (untuk performanceRankingProvider)
  List<Pond> rankByROI(List<Pond> ponds) {
    if (ponds.isEmpty) return [];
    final sortedPonds = List<Pond>.from(ponds);
    sortedPonds.sort((a, b) => b.roi.compareTo(a.roi));
    return sortedPonds;
  }

  // Mencari profit terbaik & terburuk (untuk profitabilityAnalysisProvider)
  ({Pond? best, Pond? worst}) getProfitabilityExtremes(List<Pond> ponds) {
    if (ponds.length < 2) {
      return (best: null, worst: null);
    }
    final sortedPonds = rankByProfit(ponds); // Kita bisa pakai ulang method di atas
    return (best: sortedPonds.first, worst: sortedPonds.last);
  }

  // Mencari efisiensi terbaik & terburuk (untuk efficiencyAnalysisProvider)
  ({Pond? best, Pond? worst}) getEfficiencyExtremes(List<Pond> ponds) {
    if (ponds.length < 2) {
      return (best: null, worst: null);
    }
    final sortedPonds = List<Pond>.from(ponds);
    // Ingat: FCR lebih rendah lebih baik, jadi urutkan ascending (a ke b)
    sortedPonds.sort((a, b) => a.feedConversion.compareTo(b.feedConversion));
    return (best: sortedPonds.first, worst: sortedPonds.last);
  }
}