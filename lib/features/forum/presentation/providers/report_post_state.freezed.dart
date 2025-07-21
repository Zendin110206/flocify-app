// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

// lib/features/forum/presentation/providers/report_post_state.freezed.dart

part of 'report_post_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReportPostState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get successMessage => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ReportPostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportPostStateCopyWith<ReportPostState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportPostStateCopyWith<$Res> {
  factory $ReportPostStateCopyWith(
    ReportPostState value,
    $Res Function(ReportPostState) then,
  ) = _$ReportPostStateCopyWithImpl<$Res, ReportPostState>;
  @useResult
  $Res call({bool isLoading, String? successMessage, String? errorMessage});
}

/// @nodoc
class _$ReportPostStateCopyWithImpl<$Res, $Val extends ReportPostState>
    implements $ReportPostStateCopyWith<$Res> {
  _$ReportPostStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportPostState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? successMessage = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            successMessage: freezed == successMessage
                ? _value.successMessage
                : successMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportPostStateImplCopyWith<$Res>
    implements $ReportPostStateCopyWith<$Res> {
  factory _$$ReportPostStateImplCopyWith(
    _$ReportPostStateImpl value,
    $Res Function(_$ReportPostStateImpl) then,
  ) = __$$ReportPostStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? successMessage, String? errorMessage});
}

/// @nodoc
class __$$ReportPostStateImplCopyWithImpl<$Res>
    extends _$ReportPostStateCopyWithImpl<$Res, _$ReportPostStateImpl>
    implements _$$ReportPostStateImplCopyWith<$Res> {
  __$$ReportPostStateImplCopyWithImpl(
    _$ReportPostStateImpl _value,
    $Res Function(_$ReportPostStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportPostState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? successMessage = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$ReportPostStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        successMessage: freezed == successMessage
            ? _value.successMessage
            : successMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ReportPostStateImpl implements _ReportPostState {
  const _$ReportPostStateImpl({
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? successMessage;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ReportPostState(isLoading: $isLoading, successMessage: $successMessage, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportPostStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, successMessage, errorMessage);

  /// Create a copy of ReportPostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportPostStateImplCopyWith<_$ReportPostStateImpl> get copyWith =>
      __$$ReportPostStateImplCopyWithImpl<_$ReportPostStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ReportPostState implements ReportPostState {
  const factory _ReportPostState({
    final bool isLoading,
    final String? successMessage,
    final String? errorMessage,
  }) = _$ReportPostStateImpl;

  @override
  bool get isLoading;
  @override
  String? get successMessage;
  @override
  String? get errorMessage;

  /// Create a copy of ReportPostState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportPostStateImplCopyWith<_$ReportPostStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
