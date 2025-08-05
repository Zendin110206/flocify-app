// lib/features/cultivation/presentation/providers/cultivation_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/pond_model.dart';

/// Provider untuk daftar kolam yang tersedia.
///
/// Nanti, ini akan mengambil data dari Firestore atau API.
/// Untuk sekarang, kita gunakan data dummy.
final pondListProvider = Provider<List<Pond>>((ref) {
  // --- DATA DUMMY ---
  return const [
    Pond(id: 'pond-01', name: 'Kolam 1'),
    Pond(id: 'pond-02', name: 'Kolam 2'),
    Pond(id: 'pond-03', name: 'Lele A3'),
    Pond(id: 'pond-04', name: 'Kolam 4'),
    Pond(id: 'pond-05', name: 'Udang C1'),
    Pond(id: 'pond-06', name: 'Kolam 6'),
  ];
});

/// Provider untuk menyimpan ID dari kolam yang sedang aktif/dipilih.
///
/// StateProvider digunakan karena ini adalah state simpel yang akan sering diubah oleh UI.
/// Widget lain nanti akan 'watch' provider ini untuk tahu kolam mana yang harus ditampilkan datanya.
final activePondIdProvider = StateProvider<String?>((ref) {
  // Secara default, pilih ID kolam pertama dari daftar sebagai yang aktif.
  // Ini mencegah state null saat pertama kali halaman dimuat.
  final firstPondId = ref.watch(pondListProvider).firstOrNull?.id;
  return firstPondId;
});
