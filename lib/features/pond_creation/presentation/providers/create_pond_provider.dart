// Path: lib/features/pond_creation/presentation/providers/create_pond_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/pond_wizard_state.dart';

// Provider utama untuk controller kita
final createPondProvider =
    StateNotifierProvider.autoDispose<CreatePondController, PondWizardState>((
      ref,
    ) {
      return CreatePondController();
    });

class CreatePondController extends StateNotifier<PondWizardState> {
  CreatePondController() : super(const PondWizardState());

  // Method untuk maju ke langkah berikutnya
  void nextStep() {
    if (state.currentStep < state.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  // Method untuk kembali ke langkah sebelumnya
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // Methods untuk memperbarui state berdasarkan pilihan user
  void selectCommodity(String value) =>
      state = state.copyWith(selectedCommodity: value);
  void selectPoolType(String value) =>
      state = state.copyWith(selectedPoolType: value);
  void selectPlan(String value) => state = state.copyWith(selectedPlan: value);
  void selectDevice(String? value) =>
      state = state.copyWith(selectedDevice: value);
  void setPoolName(String value) => state = state.copyWith(poolName: value);

  // Getter untuk memeriksa apakah tombol "Lanjutkan" bisa ditekan
  bool canProceed() {
    switch (state.currentStep) {
      case 0:
        return state.selectedCommodity != null;
      case 1:
        return state.selectedPoolType != null;
      case 2:
        return state.selectedPlan != null;
      case 3:
        return state.poolName.trim().isNotEmpty;
      default:
        return false;
    }
  }
}
