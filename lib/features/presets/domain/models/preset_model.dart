// lib/features/presets/domain/models/preset_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'preset_model.freezed.dart';
part 'preset_model.g.dart';

// Enum untuk menandai siapa pembuat preset
enum PresetCreator { flocify, user }

// Model untuk satu parameter di dalam preset
@freezed
class PresetParameter with _$PresetParameter {
  const factory PresetParameter({
    required String name, // e.g., 'pH'
    required double min, // e.g., 6.5
    required double max, // e.g., 7.5
    required String unit, // e.g., '' atau '°C'
  }) = _PresetParameter;

  factory PresetParameter.fromJson(Map<String, dynamic> json) =>
      _$PresetParameterFromJson(json);
}

// Model utama untuk satu preset budidaya
@freezed
class Preset with _$Preset {
  const factory Preset({
    required String id,
    required String name, // e.g., 'Lele (Pembesaran)'
    required String commodity, // e.g., 'Lele'
    required PresetCreator creator,
    String? description,
    @Default([]) List<PresetParameter> parameters,
  }) = _Preset;

  factory Preset.fromJson(Map<String, dynamic> json) => _$PresetFromJson(json);
}
