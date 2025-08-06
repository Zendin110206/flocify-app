// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PresetParameter _$PresetParameterFromJson(Map<String, dynamic> json) {
  return _PresetParameter.fromJson(json);
}

/// @nodoc
mixin _$PresetParameter {
  String get name => throw _privateConstructorUsedError; // e.g., 'pH'
  double get min => throw _privateConstructorUsedError; // e.g., 6.5
  double get max => throw _privateConstructorUsedError; // e.g., 7.5
  String get unit => throw _privateConstructorUsedError;

  /// Serializes this PresetParameter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PresetParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresetParameterCopyWith<PresetParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresetParameterCopyWith<$Res> {
  factory $PresetParameterCopyWith(
    PresetParameter value,
    $Res Function(PresetParameter) then,
  ) = _$PresetParameterCopyWithImpl<$Res, PresetParameter>;
  @useResult
  $Res call({String name, double min, double max, String unit});
}

/// @nodoc
class _$PresetParameterCopyWithImpl<$Res, $Val extends PresetParameter>
    implements $PresetParameterCopyWith<$Res> {
  _$PresetParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresetParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? min = null,
    Object? max = null,
    Object? unit = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            min: null == min
                ? _value.min
                : min // ignore: cast_nullable_to_non_nullable
                      as double,
            max: null == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PresetParameterImplCopyWith<$Res>
    implements $PresetParameterCopyWith<$Res> {
  factory _$$PresetParameterImplCopyWith(
    _$PresetParameterImpl value,
    $Res Function(_$PresetParameterImpl) then,
  ) = __$$PresetParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double min, double max, String unit});
}

/// @nodoc
class __$$PresetParameterImplCopyWithImpl<$Res>
    extends _$PresetParameterCopyWithImpl<$Res, _$PresetParameterImpl>
    implements _$$PresetParameterImplCopyWith<$Res> {
  __$$PresetParameterImplCopyWithImpl(
    _$PresetParameterImpl _value,
    $Res Function(_$PresetParameterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PresetParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? min = null,
    Object? max = null,
    Object? unit = null,
  }) {
    return _then(
      _$PresetParameterImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        min: null == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as double,
        max: null == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PresetParameterImpl implements _PresetParameter {
  const _$PresetParameterImpl({
    required this.name,
    required this.min,
    required this.max,
    required this.unit,
  });

  factory _$PresetParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresetParameterImplFromJson(json);

  @override
  final String name;
  // e.g., 'pH'
  @override
  final double min;
  // e.g., 6.5
  @override
  final double max;
  // e.g., 7.5
  @override
  final String unit;

  @override
  String toString() {
    return 'PresetParameter(name: $name, min: $min, max: $max, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresetParameterImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, min, max, unit);

  /// Create a copy of PresetParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresetParameterImplCopyWith<_$PresetParameterImpl> get copyWith =>
      __$$PresetParameterImplCopyWithImpl<_$PresetParameterImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PresetParameterImplToJson(this);
  }
}

abstract class _PresetParameter implements PresetParameter {
  const factory _PresetParameter({
    required final String name,
    required final double min,
    required final double max,
    required final String unit,
  }) = _$PresetParameterImpl;

  factory _PresetParameter.fromJson(Map<String, dynamic> json) =
      _$PresetParameterImpl.fromJson;

  @override
  String get name; // e.g., 'pH'
  @override
  double get min; // e.g., 6.5
  @override
  double get max; // e.g., 7.5
  @override
  String get unit;

  /// Create a copy of PresetParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresetParameterImplCopyWith<_$PresetParameterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Preset _$PresetFromJson(Map<String, dynamic> json) {
  return _Preset.fromJson(json);
}

/// @nodoc
mixin _$Preset {
  String get id => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // e.g., 'Lele (Pembesaran)'
  String get commodity => throw _privateConstructorUsedError; // e.g., 'Lele'
  PresetCreator get creator => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<PresetParameter> get parameters => throw _privateConstructorUsedError;

  /// Serializes this Preset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresetCopyWith<Preset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresetCopyWith<$Res> {
  factory $PresetCopyWith(Preset value, $Res Function(Preset) then) =
      _$PresetCopyWithImpl<$Res, Preset>;
  @useResult
  $Res call({
    String id,
    String name,
    String commodity,
    PresetCreator creator,
    String? description,
    List<PresetParameter> parameters,
  });
}

/// @nodoc
class _$PresetCopyWithImpl<$Res, $Val extends Preset>
    implements $PresetCopyWith<$Res> {
  _$PresetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? commodity = null,
    Object? creator = null,
    Object? description = freezed,
    Object? parameters = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            commodity: null == commodity
                ? _value.commodity
                : commodity // ignore: cast_nullable_to_non_nullable
                      as String,
            creator: null == creator
                ? _value.creator
                : creator // ignore: cast_nullable_to_non_nullable
                      as PresetCreator,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            parameters: null == parameters
                ? _value.parameters
                : parameters // ignore: cast_nullable_to_non_nullable
                      as List<PresetParameter>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PresetImplCopyWith<$Res> implements $PresetCopyWith<$Res> {
  factory _$$PresetImplCopyWith(
    _$PresetImpl value,
    $Res Function(_$PresetImpl) then,
  ) = __$$PresetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String commodity,
    PresetCreator creator,
    String? description,
    List<PresetParameter> parameters,
  });
}

/// @nodoc
class __$$PresetImplCopyWithImpl<$Res>
    extends _$PresetCopyWithImpl<$Res, _$PresetImpl>
    implements _$$PresetImplCopyWith<$Res> {
  __$$PresetImplCopyWithImpl(
    _$PresetImpl _value,
    $Res Function(_$PresetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? commodity = null,
    Object? creator = null,
    Object? description = freezed,
    Object? parameters = null,
  }) {
    return _then(
      _$PresetImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        commodity: null == commodity
            ? _value.commodity
            : commodity // ignore: cast_nullable_to_non_nullable
                  as String,
        creator: null == creator
            ? _value.creator
            : creator // ignore: cast_nullable_to_non_nullable
                  as PresetCreator,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        parameters: null == parameters
            ? _value._parameters
            : parameters // ignore: cast_nullable_to_non_nullable
                  as List<PresetParameter>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PresetImpl implements _Preset {
  const _$PresetImpl({
    required this.id,
    required this.name,
    required this.commodity,
    required this.creator,
    this.description,
    final List<PresetParameter> parameters = const [],
  }) : _parameters = parameters;

  factory _$PresetImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresetImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  // e.g., 'Lele (Pembesaran)'
  @override
  final String commodity;
  // e.g., 'Lele'
  @override
  final PresetCreator creator;
  @override
  final String? description;
  final List<PresetParameter> _parameters;
  @override
  @JsonKey()
  List<PresetParameter> get parameters {
    if (_parameters is EqualUnmodifiableListView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parameters);
  }

  @override
  String toString() {
    return 'Preset(id: $id, name: $name, commodity: $commodity, creator: $creator, description: $description, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.commodity, commodity) ||
                other.commodity == commodity) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._parameters,
              _parameters,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    commodity,
    creator,
    description,
    const DeepCollectionEquality().hash(_parameters),
  );

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresetImplCopyWith<_$PresetImpl> get copyWith =>
      __$$PresetImplCopyWithImpl<_$PresetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresetImplToJson(this);
  }
}

abstract class _Preset implements Preset {
  const factory _Preset({
    required final String id,
    required final String name,
    required final String commodity,
    required final PresetCreator creator,
    final String? description,
    final List<PresetParameter> parameters,
  }) = _$PresetImpl;

  factory _Preset.fromJson(Map<String, dynamic> json) = _$PresetImpl.fromJson;

  @override
  String get id;
  @override
  String get name; // e.g., 'Lele (Pembesaran)'
  @override
  String get commodity; // e.g., 'Lele'
  @override
  PresetCreator get creator;
  @override
  String? get description;
  @override
  List<PresetParameter> get parameters;

  /// Create a copy of Preset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresetImplCopyWith<_$PresetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
