// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_screen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CameraScreenState {
  // Status keseluruhan halaman untuk mengontrol UI (misal: tampilkan loading)
  CameraStatus get status =>
      throw _privateConstructorUsedError; // Daftar panduan yang akan ditampilkan di carousel
  List<DetectionGuide> get guides =>
      throw _privateConstructorUsedError; // Menyimpan gambar yang sudah diambil.
  // Key-nya adalah ID panduan (e.g., 'left_side'), Value-nya adalah file gambar.
  Map<String, File> get capturedImages =>
      throw _privateConstructorUsedError; // ID dari panduan yang sedang aktif/dipilih oleh pengguna.
  String? get currentGuideId =>
      throw _privateConstructorUsedError; // Untuk menyimpan pesan error jika terjadi kesalahan.
  String? get errorMessage =>
      throw _privateConstructorUsedError; // 'Slot' untuk menyimpan hasil analisis yang berhasil.
  AnalysisResult? get analysisResult => throw _privateConstructorUsedError;

  /// Create a copy of CameraScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CameraScreenStateCopyWith<CameraScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraScreenStateCopyWith<$Res> {
  factory $CameraScreenStateCopyWith(
    CameraScreenState value,
    $Res Function(CameraScreenState) then,
  ) = _$CameraScreenStateCopyWithImpl<$Res, CameraScreenState>;
  @useResult
  $Res call({
    CameraStatus status,
    List<DetectionGuide> guides,
    Map<String, File> capturedImages,
    String? currentGuideId,
    String? errorMessage,
    AnalysisResult? analysisResult,
  });

  $AnalysisResultCopyWith<$Res>? get analysisResult;
}

/// @nodoc
class _$CameraScreenStateCopyWithImpl<$Res, $Val extends CameraScreenState>
    implements $CameraScreenStateCopyWith<$Res> {
  _$CameraScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CameraScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? guides = null,
    Object? capturedImages = null,
    Object? currentGuideId = freezed,
    Object? errorMessage = freezed,
    Object? analysisResult = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as CameraStatus,
            guides: null == guides
                ? _value.guides
                : guides // ignore: cast_nullable_to_non_nullable
                      as List<DetectionGuide>,
            capturedImages: null == capturedImages
                ? _value.capturedImages
                : capturedImages // ignore: cast_nullable_to_non_nullable
                      as Map<String, File>,
            currentGuideId: freezed == currentGuideId
                ? _value.currentGuideId
                : currentGuideId // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            analysisResult: freezed == analysisResult
                ? _value.analysisResult
                : analysisResult // ignore: cast_nullable_to_non_nullable
                      as AnalysisResult?,
          )
          as $Val,
    );
  }

  /// Create a copy of CameraScreenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisResultCopyWith<$Res>? get analysisResult {
    if (_value.analysisResult == null) {
      return null;
    }

    return $AnalysisResultCopyWith<$Res>(_value.analysisResult!, (value) {
      return _then(_value.copyWith(analysisResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CameraScreenStateImplCopyWith<$Res>
    implements $CameraScreenStateCopyWith<$Res> {
  factory _$$CameraScreenStateImplCopyWith(
    _$CameraScreenStateImpl value,
    $Res Function(_$CameraScreenStateImpl) then,
  ) = __$$CameraScreenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CameraStatus status,
    List<DetectionGuide> guides,
    Map<String, File> capturedImages,
    String? currentGuideId,
    String? errorMessage,
    AnalysisResult? analysisResult,
  });

  @override
  $AnalysisResultCopyWith<$Res>? get analysisResult;
}

/// @nodoc
class __$$CameraScreenStateImplCopyWithImpl<$Res>
    extends _$CameraScreenStateCopyWithImpl<$Res, _$CameraScreenStateImpl>
    implements _$$CameraScreenStateImplCopyWith<$Res> {
  __$$CameraScreenStateImplCopyWithImpl(
    _$CameraScreenStateImpl _value,
    $Res Function(_$CameraScreenStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CameraScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? guides = null,
    Object? capturedImages = null,
    Object? currentGuideId = freezed,
    Object? errorMessage = freezed,
    Object? analysisResult = freezed,
  }) {
    return _then(
      _$CameraScreenStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as CameraStatus,
        guides: null == guides
            ? _value._guides
            : guides // ignore: cast_nullable_to_non_nullable
                  as List<DetectionGuide>,
        capturedImages: null == capturedImages
            ? _value._capturedImages
            : capturedImages // ignore: cast_nullable_to_non_nullable
                  as Map<String, File>,
        currentGuideId: freezed == currentGuideId
            ? _value.currentGuideId
            : currentGuideId // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        analysisResult: freezed == analysisResult
            ? _value.analysisResult
            : analysisResult // ignore: cast_nullable_to_non_nullable
                  as AnalysisResult?,
      ),
    );
  }
}

/// @nodoc

class _$CameraScreenStateImpl implements _CameraScreenState {
  const _$CameraScreenStateImpl({
    this.status = CameraStatus.initial,
    final List<DetectionGuide> guides = const [],
    final Map<String, File> capturedImages = const {},
    this.currentGuideId,
    this.errorMessage,
    this.analysisResult,
  }) : _guides = guides,
       _capturedImages = capturedImages;

  // Status keseluruhan halaman untuk mengontrol UI (misal: tampilkan loading)
  @override
  @JsonKey()
  final CameraStatus status;
  // Daftar panduan yang akan ditampilkan di carousel
  final List<DetectionGuide> _guides;
  // Daftar panduan yang akan ditampilkan di carousel
  @override
  @JsonKey()
  List<DetectionGuide> get guides {
    if (_guides is EqualUnmodifiableListView) return _guides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guides);
  }

  // Menyimpan gambar yang sudah diambil.
  // Key-nya adalah ID panduan (e.g., 'left_side'), Value-nya adalah file gambar.
  final Map<String, File> _capturedImages;
  // Menyimpan gambar yang sudah diambil.
  // Key-nya adalah ID panduan (e.g., 'left_side'), Value-nya adalah file gambar.
  @override
  @JsonKey()
  Map<String, File> get capturedImages {
    if (_capturedImages is EqualUnmodifiableMapView) return _capturedImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_capturedImages);
  }

  // ID dari panduan yang sedang aktif/dipilih oleh pengguna.
  @override
  final String? currentGuideId;
  // Untuk menyimpan pesan error jika terjadi kesalahan.
  @override
  final String? errorMessage;
  // 'Slot' untuk menyimpan hasil analisis yang berhasil.
  @override
  final AnalysisResult? analysisResult;

  @override
  String toString() {
    return 'CameraScreenState(status: $status, guides: $guides, capturedImages: $capturedImages, currentGuideId: $currentGuideId, errorMessage: $errorMessage, analysisResult: $analysisResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraScreenStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._guides, _guides) &&
            const DeepCollectionEquality().equals(
              other._capturedImages,
              _capturedImages,
            ) &&
            (identical(other.currentGuideId, currentGuideId) ||
                other.currentGuideId == currentGuideId) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.analysisResult, analysisResult) ||
                other.analysisResult == analysisResult));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_guides),
    const DeepCollectionEquality().hash(_capturedImages),
    currentGuideId,
    errorMessage,
    analysisResult,
  );

  /// Create a copy of CameraScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CameraScreenStateImplCopyWith<_$CameraScreenStateImpl> get copyWith =>
      __$$CameraScreenStateImplCopyWithImpl<_$CameraScreenStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CameraScreenState implements CameraScreenState {
  const factory _CameraScreenState({
    final CameraStatus status,
    final List<DetectionGuide> guides,
    final Map<String, File> capturedImages,
    final String? currentGuideId,
    final String? errorMessage,
    final AnalysisResult? analysisResult,
  }) = _$CameraScreenStateImpl;

  // Status keseluruhan halaman untuk mengontrol UI (misal: tampilkan loading)
  @override
  CameraStatus get status; // Daftar panduan yang akan ditampilkan di carousel
  @override
  List<DetectionGuide> get guides; // Menyimpan gambar yang sudah diambil.
  // Key-nya adalah ID panduan (e.g., 'left_side'), Value-nya adalah file gambar.
  @override
  Map<String, File> get capturedImages; // ID dari panduan yang sedang aktif/dipilih oleh pengguna.
  @override
  String? get currentGuideId; // Untuk menyimpan pesan error jika terjadi kesalahan.
  @override
  String? get errorMessage; // 'Slot' untuk menyimpan hasil analisis yang berhasil.
  @override
  AnalysisResult? get analysisResult;

  /// Create a copy of CameraScreenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CameraScreenStateImplCopyWith<_$CameraScreenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
