// lib/features/home/data/repositories/home_repository.dart
import '../../domain/models/home_pond_status_model.dart';

// Kontrak
abstract class HomeRepository {
  Future<List<HomePondStatus>> getPondStatuses();
}

// Implementasi Palsu (mengambil data dari kode lama)
class FakeHomeRepository implements HomeRepository {
  @override
  Future<List<HomePondStatus>> getPondStatuses() async {
    // Simulasi panggilan jaringan
    await Future.delayed(const Duration(milliseconds: 800));

    // Data dummy dari kode lama, diubah menjadi model yang aman
    return [
      HomePondStatus(title: 'Kolam 1', descriptions: ['pH anomali (8.5)', 'Oksigen rendah (4.1 mg/L)'], status: PondStatus.critical, commodity: 'Nila'),
      HomePondStatus(title: 'Kolam 2', descriptions: ['Pakan hampir habis'], status: PondStatus.warning, commodity: 'Udang Vaname'),
      HomePondStatus(title: 'Kolam 3', descriptions: ['Amonia tinggi'], status: PondStatus.critical, commodity: 'Lele'),
      HomePondStatus(title: 'Kolam 4', descriptions: ['Oksigen rendah'], status: PondStatus.warning, commodity: 'Nila'),
      HomePondStatus(title: 'Kolam 5', descriptions: ['Suhu tidak stabil'], status: PondStatus.warning, commodity: 'Gurame'),
      HomePondStatus(title: 'Kolam 6', descriptions: ['Kualitas air normal'], status: PondStatus.normal, commodity: 'Patin'),
    ];
  }
}