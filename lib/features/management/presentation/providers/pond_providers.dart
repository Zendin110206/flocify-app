// lib/features/management/presentation/providers/pond_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/pond_repository.dart';
import '../../domain/models/pond_model.dart';
import '../../domain/models/pond_summary_model.dart';
import '../../domain/usecases/get_pond_summary_usecase.dart';
import '../../domain/usecases/analyze_ponds_usecase.dart';
import '../../domain/usecases/filter_ponds_usecase.dart';

// --- LAPISAN DATA ---
final pondRepositoryProvider = Provider<PondRepository>((ref) {
  return FakePondRepository();
});

final pondListProvider = FutureProvider.autoDispose<List<Pond>>((ref) {
  final repository = ref.watch(pondRepositoryProvider);
  return repository.getPonds();
});

// --- LAPISAN STATE FILTER (UI STATE) ---
final selectedPondFilterProvider = StateProvider.autoDispose<String>((ref) {
  return 'Semua Kolam';
});

final selectedPeriodFilterProvider = StateProvider.autoDispose<String>((ref) {
  return 'Bulan Ini';
});

final managementTabProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

// --- LAPISAN USE CASE (PARA 'KOKI') ---
final getPondSummaryUseCaseProvider = Provider(
  (ref) => GetPondSummaryUseCase(),
);
final filterPondsUseCaseProvider = Provider((ref) => FilterPondsUseCase());
final analyzePondsUseCaseProvider = Provider((ref) => AnalyzePondsUseCase());

// --- LAPISAN PRESENTASI (DATA OLAHAN/'HIDANGAN') ---

// Provider ini sekarang hanya memanggil Use Case filter
final filteredPondListProvider = Provider.autoDispose<List<Pond>>((ref) {
  final allPonds = ref.watch(pondListProvider).asData?.value ?? [];
  final selectedPond = ref.watch(selectedPondFilterProvider);
  final selectedPeriod = ref.watch(selectedPeriodFilterProvider);

  final useCase = ref.read(filterPondsUseCaseProvider);
  return useCase.call(
    allPonds: allPonds,
    selectedPond: selectedPond,
    selectedPeriod: selectedPeriod,
  );
});

// Provider ini tidak punya logika kompleks, jadi tidak perlu Use Case.
final pondNameListProvider = Provider.autoDispose<List<String>>((ref) {
  final allPonds = ref.watch(pondListProvider).asData?.value ?? [];
  final uniqueNames = allPonds.map((pond) => pond.name).toSet().toList();
  return ['Semua Kolam', ...uniqueNames];
});

// Provider ini sudah benar menggunakan Use Case
final pondSummaryProvider = Provider.autoDispose<PondSummary>((ref) {
  final allPonds = ref.watch(pondListProvider).asData?.value ?? [];
  final useCase = ref.read(getPondSummaryUseCaseProvider);
  return useCase.call(ponds: allPonds);
});

// Semua provider analisis sekarang memanggil AnalyzePondsUseCase
final topPerformingPondsProvider = Provider.autoDispose<List<Pond>>((ref) {
  final allPonds = ref.watch(pondListProvider).asData?.value ?? [];
  final useCase = ref.read(analyzePondsUseCaseProvider);
  return useCase.rankByProfit(allPonds);
});

final performanceRankingProvider = Provider.autoDispose<List<Pond>>((ref) {
  final allPonds = ref.watch(pondListProvider).asData?.value ?? [];
  final useCase = ref.read(analyzePondsUseCaseProvider);
  return useCase.rankByROI(allPonds);
});

final profitabilityAnalysisProvider =
    Provider.autoDispose<({Pond? best, Pond? worst})>((ref) {
      final allPonds = ref.watch(pondListProvider).asData?.value ?? [];
      final useCase = ref.read(analyzePondsUseCaseProvider);
      return useCase.getProfitabilityExtremes(allPonds);
    });

final efficiencyAnalysisProvider =
    Provider.autoDispose<({Pond? best, Pond? worst})>((ref) {
      final allPonds = ref.watch(pondListProvider).asData?.value ?? [];
      final useCase = ref.read(analyzePondsUseCaseProvider);
      return useCase.getEfficiencyExtremes(allPonds);
    });
