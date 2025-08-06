// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PresetParameterImpl _$$PresetParameterImplFromJson(
  Map<String, dynamic> json,
) => _$PresetParameterImpl(
  name: json['name'] as String,
  min: (json['min'] as num).toDouble(),
  max: (json['max'] as num).toDouble(),
  unit: json['unit'] as String,
);

Map<String, dynamic> _$$PresetParameterImplToJson(
  _$PresetParameterImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'min': instance.min,
  'max': instance.max,
  'unit': instance.unit,
};

_$PresetImpl _$$PresetImplFromJson(Map<String, dynamic> json) => _$PresetImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  commodity: json['commodity'] as String,
  creator: $enumDecode(_$PresetCreatorEnumMap, json['creator']),
  description: json['description'] as String?,
  parameters:
      (json['parameters'] as List<dynamic>?)
          ?.map((e) => PresetParameter.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PresetImplToJson(_$PresetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'commodity': instance.commodity,
      'creator': _$PresetCreatorEnumMap[instance.creator]!,
      'description': instance.description,
      'parameters': instance.parameters,
    };

const _$PresetCreatorEnumMap = {
  PresetCreator.flocify: 'flocify',
  PresetCreator.user: 'user',
};
