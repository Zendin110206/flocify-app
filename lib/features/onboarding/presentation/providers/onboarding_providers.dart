// lib/features/onboarding/presentation/providers/onboarding_providers.dart


import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import yang dibutuhkan di onboarding_providers.dart
import 'package:proyek_flocify/features/management/domain/models/pond_model.dart';
import 'package:proyek_flocify/features/management/presentation/providers/pond_providers.dart';

class PondConfigData {
  final String commodity;
  final String pondType;
  final double salesTarget;
  // Tambahkan field lain sesuai kebutuhan

  PondConfigData({
    required this.commodity,
    required this.pondType,
    required this.salesTarget,
  });
}

// State untuk menyimpan semua data onboarding
class OnboardingState {
  final int totalPonds;
  final int currentPondIndex;
  // TAMBAHKAN INI: List untuk menyimpan data konfigurasi
  final List<PondConfigData> pondConfigs;

  OnboardingState({
    this.totalPonds = 0,
    this.currentPondIndex = 1,
    this.pondConfigs = const [], // Inisialisasi list kosong
  });

  OnboardingState copyWith({
    int? totalPonds,
    int? currentPondIndex,
    List<PondConfigData>? pondConfigs,
  }) {
    return OnboardingState(
      totalPonds: totalPonds ?? this.totalPonds,
      currentPondIndex: currentPondIndex ?? this.currentPondIndex,
      pondConfigs: pondConfigs ?? this.pondConfigs,
    );
  }
}

// Controller yang akan mengelola state di atas
class OnboardingController extends StateNotifier<OnboardingState> {
  // TAMBAHKAN REF AGAR BISA MEMANGGIL REPOSITORY
  final Ref ref;
  OnboardingController(this.ref) : super(OnboardingState());

  void setTotalPonds(int count) {
    state = state.copyWith(
      totalPonds: count,
      currentPondIndex: 1,
      pondConfigs: [], // Reset data saat jumlah kolam di-set
    );
  }

  // UBAH METHOD INI UNTUK MENERIMA DATA
  void completePondConfiguration(PondConfigData data) {
    final newConfigs = [...state.pondConfigs, data];
    state = state.copyWith(pondConfigs: newConfigs);

    if (state.currentPondIndex < state.totalPonds) {
      state = state.copyWith(currentPondIndex: state.currentPondIndex + 1);
    } else {
      // Proses selesai, kita akan tambahkan logika "handover" data di sini nanti
      _finalizeOnboarding();
    }
  }

  Future<void> _finalizeOnboarding() async {
    print("Onboarding Selesai! Melakukan handover data...");

    // 1. Ubah data konfigurasi menjadi Pond model yang sebenarnya
    final newPonds = state.pondConfigs.asMap().entries.map((entry) {
      int index = entry.key;
      PondConfigData config = entry.value;
      // Ini hanya contoh, Anda bisa membuat data Pond yang lebih detail
      return Pond(
        id: 'P00${index + 10}', // Buat ID unik sementara
        name: 'Kolam ${config.commodity} ${index + 1}',
        fishType: config.commodity,
        // Isi properti lain dengan nilai default atau dari form
        size: config.pondType,
        capacity: 5000,
        population: 0,
        age: 0,
        harvestTarget: 90,
        feedConversion: 0,
        mortality: 0,
        profit: 0,
        roi: 0,
        status: 'Baru',
        totalFeedCost: 0,
        totalSales: 0,
        estimatedHarvest: DateTime.now().add(const Duration(days: 90)),
        avgWeight: 0,
        waterQuality: 'Baik',
        temperature: 28,
        ph: 7,
        oxygen: 6,
      );
    }).toList();

    // 2. Panggil repository untuk menyimpan data awal ini
    await ref.read(pondRepositoryProvider).initializePonds(newPonds);

    // 3. (SANGAT PENTING) Invalidate provider agar UI di tempat lain refresh
    ref.invalidate(pondListProvider);
  }
}

// Perbarui juga providernya untuk memasukkan 'ref'
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
      return OnboardingController(ref);
    });
