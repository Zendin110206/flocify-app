// lib/features/home/presentation/providers/home_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/home_repository.dart';
import '../../domain/models/home_pond_status_model.dart';

// --- Provider Lapisan Data ---
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return FakeHomeRepository();
});

final pondStatusProvider = FutureProvider.autoDispose<List<HomePondStatus>>((
  ref,
) {
  return ref.watch(homeRepositoryProvider).getPondStatuses();
});

// --- Provider untuk State UI ---
// Menggantikan _selectedCommodity di setState
final selectedCommodityProvider = StateProvider.autoDispose<String>(
  (ref) => 'Semua',
);

// Menggantikan _selectedCategoryIndex di setState
final selectedCategoryProvider = StateProvider.autoDispose<int>((ref) => 0);

// Menggantikan _currentCarouselIndex di setState
final carouselIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

// --- Provider untuk Data Turunan (Derived State) ---
// Provider untuk daftar komoditas unik (untuk filter)
final commodityListProvider = Provider.autoDispose<List<String>>((ref) {
  final ponds = ref.watch(pondStatusProvider).asData?.value ?? [];
  final uniqueCommodities = ponds.map((p) => p.commodity).toSet().toList();
  return ['Semua', ...uniqueCommodities];
});

// Provider untuk data kolam yang sudah difilter
final filteredPondStatusProvider = Provider.autoDispose<List<HomePondStatus>>((
  ref,
) {
  final selectedCommodity = ref.watch(selectedCommodityProvider);
  final allPonds = ref.watch(pondStatusProvider).asData?.value ?? [];

  if (selectedCommodity == 'Semua') {
    return allPonds;
  }
  return allPonds.where((pond) => pond.commodity == selectedCommodity).toList();
});
