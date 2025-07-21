import '../../domain/models/pond_model.dart';

// Ini adalah "Kontrak" atau "Blueprint" untuk Pemasok data kolam kita.
abstract class PondRepository {
  Future<List<Pond>> getPonds();
  Future<void> initializePonds(List<Pond> initialPonds);
}

// Ini adalah implementasi "Palsu" dari Pemasok kita.
class FakePondRepository implements PondRepository {
  // Daftar ini sekarang bisa diubah, karena itu kita hapus 'final'
  List<Pond> _dummyPonds = [
    Pond(
      id: 'P001',
      name: 'Kolam A1',
      fishType: 'Lele',
      size: '10x8 meter',
      capacity: 5000,
      population: 4800,
      age: 65,
      harvestTarget: 80,
      feedConversion: 1.2,
      mortality: 4.0,
      profit: 3200000,
      roi: 28.5,
      status: 'Aktif',
      totalFeedCost: 2850000,
      totalSales: 6500000,
      estimatedHarvest: DateTime.parse('2025-07-31'),
      avgWeight: 250,
      waterQuality: 'Baik',
      temperature: 26.5,
      ph: 7.2,
      oxygen: 6.8,
    ),
    // ... data dummy lainnya tetap ada di sini ...
    Pond(
      id: 'P005',
      name: 'Kolam C1',
      fishType: 'Lele',
      size: '14x10 meter',
      capacity: 7000,
      population: 6300,
      age: 25,
      harvestTarget: 80,
      feedConversion: 1.3,
      mortality: 3.8,
      profit: 850000,
      roi: 12.3,
      status: 'Baru',
      totalFeedCost: 1200000,
      totalSales: 2850000,
      estimatedHarvest: DateTime.parse('2025-09-25'),
      avgWeight: 80,
      waterQuality: 'Baik',
      temperature: 26.9,
      ph: 7.1,
      oxygen: 7.0,
    ),
  ];

  // --- METHOD YANG HILANG ---
  // Tambahkan kembali method ini
  @override
  Future<List<Pond>> getPonds() async {
    // Kita beri sedikit jeda untuk mensimulasikan panggilan ke internet/database.
    await Future.delayed(const Duration(milliseconds: 500));
    // Kembalikan daftar data dummy kita.
    return _dummyPonds;
  }
  // -------------------------

  @override
  Future<void> initializePonds(List<Pond> initialPonds) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _dummyPonds = initialPonds;
    print(
      'FakePondRepository: ${initialPonds.length} kolam baru telah diinisialisasi.',
    );
  }
}
