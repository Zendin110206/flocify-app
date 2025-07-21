// lib/features/management/domain/models/pond_summary_model.dart

// Cetakan untuk data ringkasan semua kolam.
class PondSummary {
  final int activePonds;
  final int totalPonds;
  final int totalPopulation;
  final double averageROI;
  final int readyToHarvest;

  const PondSummary({
    required this.activePonds,
    required this.totalPonds,
    required this.totalPopulation,
    required this.averageROI,
    required this.readyToHarvest,
  });
}
