// Path: lib/features/asset_management/tab/pond_creation/domain/models/pond_wizard_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pond_wizard_state.freezed.dart';

@freezed
class PondWizardState with _$PondWizardState {
  const factory PondWizardState({
    @Default(0) int currentStep,
    @Default(4) int totalSteps,
    String? selectedCommodity,
    String? selectedPoolType,
    String? selectedPlan,
    String? selectedDevice,
    @Default('') String poolName,
  }) = _PondWizardState;
}
