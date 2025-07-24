// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) {
  return _AnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResult {
  String get id => throw _privateConstructorUsedError;
  String get fishType => throw _privateConstructorUsedError;
  String get healthStatus =>
      throw _privateConstructorUsedError; // Menggunakan double (misal: 0.85) lebih standar untuk confidence score dari sebuah model AI
  double get confidence => throw _privateConstructorUsedError;
  List<String> get symptoms => throw _privateConstructorUsedError;
  List<String> get recommendations =>
      throw _privateConstructorUsedError; // Menyertakan imageUrl di sini akan mempermudah saat menampilkannya di halaman hasil
  String get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this AnalysisResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisResultCopyWith<AnalysisResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisResultCopyWith<$Res> {
  factory $AnalysisResultCopyWith(
    AnalysisResult value,
    $Res Function(AnalysisResult) then,
  ) = _$AnalysisResultCopyWithImpl<$Res, AnalysisResult>;
  @useResult
  $Res call({
    String id,
    String fishType,
    String healthStatus,
    double confidence,
    List<String> symptoms,
    List<String> recommendations,
    String imageUrl,
  });
}

/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res, $Val extends AnalysisResult>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fishType = null,
    Object? healthStatus = null,
    Object? confidence = null,
    Object? symptoms = null,
    Object? recommendations = null,
    Object? imageUrl = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fishType: null == fishType
                ? _value.fishType
                : fishType // ignore: cast_nullable_to_non_nullable
                      as String,
            healthStatus: null == healthStatus
                ? _value.healthStatus
                : healthStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalysisResultImplCopyWith<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  factory _$$AnalysisResultImplCopyWith(
    _$AnalysisResultImpl value,
    $Res Function(_$AnalysisResultImpl) then,
  ) = __$$AnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fishType,
    String healthStatus,
    double confidence,
    List<String> symptoms,
    List<String> recommendations,
    String imageUrl,
  });
}

/// @nodoc
class __$$AnalysisResultImplCopyWithImpl<$Res>
    extends _$AnalysisResultCopyWithImpl<$Res, _$AnalysisResultImpl>
    implements _$$AnalysisResultImplCopyWith<$Res> {
  __$$AnalysisResultImplCopyWithImpl(
    _$AnalysisResultImpl _value,
    $Res Function(_$AnalysisResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fishType = null,
    Object? healthStatus = null,
    Object? confidence = null,
    Object? symptoms = null,
    Object? recommendations = null,
    Object? imageUrl = null,
  }) {
    return _then(
      _$AnalysisResultImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fishType: null == fishType
            ? _value.fishType
            : fishType // ignore: cast_nullable_to_non_nullable
                  as String,
        healthStatus: null == healthStatus
            ? _value.healthStatus
            : healthStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        symptoms: null == symptoms
            ? _value._symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResultImpl implements _AnalysisResult {
  const _$AnalysisResultImpl({
    required this.id,
    required this.fishType,
    required this.healthStatus,
    required this.confidence,
    required final List<String> symptoms,
    required final List<String> recommendations,
    required this.imageUrl,
  }) : _symptoms = symptoms,
       _recommendations = recommendations;

  factory _$AnalysisResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResultImplFromJson(json);

  @override
  final String id;
  @override
  final String fishType;
  @override
  final String healthStatus;
  // Menggunakan double (misal: 0.85) lebih standar untuk confidence score dari sebuah model AI
  @override
  final double confidence;
  final List<String> _symptoms;
  @override
  List<String> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  // Menyertakan imageUrl di sini akan mempermudah saat menampilkannya di halaman hasil
  @override
  final String imageUrl;

  @override
  String toString() {
    return 'AnalysisResult(id: $id, fishType: $fishType, healthStatus: $healthStatus, confidence: $confidence, symptoms: $symptoms, recommendations: $recommendations, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fishType, fishType) ||
                other.fishType == fishType) &&
            (identical(other.healthStatus, healthStatus) ||
                other.healthStatus == healthStatus) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fishType,
    healthStatus,
    confidence,
    const DeepCollectionEquality().hash(_symptoms),
    const DeepCollectionEquality().hash(_recommendations),
    imageUrl,
  );

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      __$$AnalysisResultImplCopyWithImpl<_$AnalysisResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisResultImplToJson(this);
  }
}

abstract class _AnalysisResult implements AnalysisResult {
  const factory _AnalysisResult({
    required final String id,
    required final String fishType,
    required final String healthStatus,
    required final double confidence,
    required final List<String> symptoms,
    required final List<String> recommendations,
    required final String imageUrl,
  }) = _$AnalysisResultImpl;

  factory _AnalysisResult.fromJson(Map<String, dynamic> json) =
      _$AnalysisResultImpl.fromJson;

  @override
  String get id;
  @override
  String get fishType;
  @override
  String get healthStatus; // Menggunakan double (misal: 0.85) lebih standar untuk confidence score dari sebuah model AI
  @override
  double get confidence;
  @override
  List<String> get symptoms;
  @override
  List<String> get recommendations; // Menyertakan imageUrl di sini akan mempermudah saat menampilkannya di halaman hasil
  @override
  String get imageUrl;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
