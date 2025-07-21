// lib/features/management/domain/models/pond_model.dart

// Ini adalah definisi "cetakan" untuk data sebuah kolam.
// Menggunakan class seperti ini memastikan data kita type-safe,
// artinya kita tidak akan salah ketik nama field (misal 'jenis' vs 'fishType').

class Pond {
  final String id;
  final String name;
  final String fishType;
  final String size;
  final int capacity;
  final int population;
  final int age; // dalam hari
  final int harvestTarget; // dalam hari
  final double feedConversion;
  final double mortality;
  final double profit;
  final double roi;
  final String status;
  final double totalFeedCost;
  final double totalSales;
  final DateTime estimatedHarvest;
  final double avgWeight; // dalam gram
  final String waterQuality;
  final double temperature;
  final double ph;
  final double oxygen;

  const Pond({
    required this.id,
    required this.name,
    required this.fishType,
    required this.size,
    required this.capacity,
    required this.population,
    required this.age,
    required this.harvestTarget,
    required this.feedConversion,
    required this.mortality,
    required this.profit,
    required this.roi,
    required this.status,
    required this.totalFeedCost,
    required this.totalSales,
    required this.estimatedHarvest,
    required this.avgWeight,
    required this.waterQuality,
    required this.temperature,
    required this.ph,
    required this.oxygen,
  });
}
