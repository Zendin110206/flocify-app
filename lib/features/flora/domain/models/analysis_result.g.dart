// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisResultImpl _$$AnalysisResultImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisResultImpl(
      id: json['id'] as String,
      fishType: json['fishType'] as String,
      healthStatus: json['healthStatus'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      symptoms: (json['symptoms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$$AnalysisResultImplToJson(
  _$AnalysisResultImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fishType': instance.fishType,
  'healthStatus': instance.healthStatus,
  'confidence': instance.confidence,
  'symptoms': instance.symptoms,
  'recommendations': instance.recommendations,
  'imageUrl': instance.imageUrl,
};
