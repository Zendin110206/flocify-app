// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  // Informasi Wajib untuk SEMUA Peran
  // Mengganti 'id' menjadi 'uid' agar konsisten dengan Firebase Auth
  String get uid => throw _privateConstructorUsedError;
  String get email =>
      throw _privateConstructorUsedError; // Mengganti 'name' menjadi 'fullName' agar lebih deskriptif
  String get fullName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  UserRole get role =>
      throw _privateConstructorUsedError; // Mengganti 'avatarUrl' menjadi 'photoUrl' agar konsisten
  String? get photoUrl =>
      throw _privateConstructorUsedError; // Informasi Spesifik Peternak (Farmer)
  String? get farmName => throw _privateConstructorUsedError;
  String? get farmLocation => throw _privateConstructorUsedError;
  int? get farmingExperienceYears => throw _privateConstructorUsedError;
  String? get mainCommodity => throw _privateConstructorUsedError;
  String? get farmingSystem => throw _privateConstructorUsedError;
  int? get pondCount => throw _privateConstructorUsedError;
  double? get totalAreaSqm =>
      throw _privateConstructorUsedError; // Informasi Spesifik Pembeli (Buyer)
  String? get buyerBusinessName => throw _privateConstructorUsedError;
  String? get buyerBusinessType => throw _privateConstructorUsedError;
  String? get buyerBusinessLocation => throw _privateConstructorUsedError;
  int? get purchaseCapacityKgPerMonth => throw _privateConstructorUsedError;
  List<String> get interestedCommodities =>
      throw _privateConstructorUsedError; // Informasi Spesifik Supplier
  String? get storeName => throw _privateConstructorUsedError;
  String? get storeLocation => throw _privateConstructorUsedError;
  List<String> get suppliedProducts =>
      throw _privateConstructorUsedError; // Metadata
  bool get isNewUser => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String uid,
    String email,
    String fullName,
    String phoneNumber,
    UserRole role,
    String? photoUrl,
    String? farmName,
    String? farmLocation,
    int? farmingExperienceYears,
    String? mainCommodity,
    String? farmingSystem,
    int? pondCount,
    double? totalAreaSqm,
    String? buyerBusinessName,
    String? buyerBusinessType,
    String? buyerBusinessLocation,
    int? purchaseCapacityKgPerMonth,
    List<String> interestedCommodities,
    String? storeName,
    String? storeLocation,
    List<String> suppliedProducts,
    bool isNewUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? fullName = null,
    Object? phoneNumber = null,
    Object? role = null,
    Object? photoUrl = freezed,
    Object? farmName = freezed,
    Object? farmLocation = freezed,
    Object? farmingExperienceYears = freezed,
    Object? mainCommodity = freezed,
    Object? farmingSystem = freezed,
    Object? pondCount = freezed,
    Object? totalAreaSqm = freezed,
    Object? buyerBusinessName = freezed,
    Object? buyerBusinessType = freezed,
    Object? buyerBusinessLocation = freezed,
    Object? purchaseCapacityKgPerMonth = freezed,
    Object? interestedCommodities = null,
    Object? storeName = freezed,
    Object? storeLocation = freezed,
    Object? suppliedProducts = null,
    Object? isNewUser = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmName: freezed == farmName
                ? _value.farmName
                : farmName // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmLocation: freezed == farmLocation
                ? _value.farmLocation
                : farmLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmingExperienceYears: freezed == farmingExperienceYears
                ? _value.farmingExperienceYears
                : farmingExperienceYears // ignore: cast_nullable_to_non_nullable
                      as int?,
            mainCommodity: freezed == mainCommodity
                ? _value.mainCommodity
                : mainCommodity // ignore: cast_nullable_to_non_nullable
                      as String?,
            farmingSystem: freezed == farmingSystem
                ? _value.farmingSystem
                : farmingSystem // ignore: cast_nullable_to_non_nullable
                      as String?,
            pondCount: freezed == pondCount
                ? _value.pondCount
                : pondCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalAreaSqm: freezed == totalAreaSqm
                ? _value.totalAreaSqm
                : totalAreaSqm // ignore: cast_nullable_to_non_nullable
                      as double?,
            buyerBusinessName: freezed == buyerBusinessName
                ? _value.buyerBusinessName
                : buyerBusinessName // ignore: cast_nullable_to_non_nullable
                      as String?,
            buyerBusinessType: freezed == buyerBusinessType
                ? _value.buyerBusinessType
                : buyerBusinessType // ignore: cast_nullable_to_non_nullable
                      as String?,
            buyerBusinessLocation: freezed == buyerBusinessLocation
                ? _value.buyerBusinessLocation
                : buyerBusinessLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            purchaseCapacityKgPerMonth: freezed == purchaseCapacityKgPerMonth
                ? _value.purchaseCapacityKgPerMonth
                : purchaseCapacityKgPerMonth // ignore: cast_nullable_to_non_nullable
                      as int?,
            interestedCommodities: null == interestedCommodities
                ? _value.interestedCommodities
                : interestedCommodities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            storeName: freezed == storeName
                ? _value.storeName
                : storeName // ignore: cast_nullable_to_non_nullable
                      as String?,
            storeLocation: freezed == storeLocation
                ? _value.storeLocation
                : storeLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            suppliedProducts: null == suppliedProducts
                ? _value.suppliedProducts
                : suppliedProducts // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isNewUser: null == isNewUser
                ? _value.isNewUser
                : isNewUser // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String email,
    String fullName,
    String phoneNumber,
    UserRole role,
    String? photoUrl,
    String? farmName,
    String? farmLocation,
    int? farmingExperienceYears,
    String? mainCommodity,
    String? farmingSystem,
    int? pondCount,
    double? totalAreaSqm,
    String? buyerBusinessName,
    String? buyerBusinessType,
    String? buyerBusinessLocation,
    int? purchaseCapacityKgPerMonth,
    List<String> interestedCommodities,
    String? storeName,
    String? storeLocation,
    List<String> suppliedProducts,
    bool isNewUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? fullName = null,
    Object? phoneNumber = null,
    Object? role = null,
    Object? photoUrl = freezed,
    Object? farmName = freezed,
    Object? farmLocation = freezed,
    Object? farmingExperienceYears = freezed,
    Object? mainCommodity = freezed,
    Object? farmingSystem = freezed,
    Object? pondCount = freezed,
    Object? totalAreaSqm = freezed,
    Object? buyerBusinessName = freezed,
    Object? buyerBusinessType = freezed,
    Object? buyerBusinessLocation = freezed,
    Object? purchaseCapacityKgPerMonth = freezed,
    Object? interestedCommodities = null,
    Object? storeName = freezed,
    Object? storeLocation = freezed,
    Object? suppliedProducts = null,
    Object? isNewUser = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserProfileImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmName: freezed == farmName
            ? _value.farmName
            : farmName // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmLocation: freezed == farmLocation
            ? _value.farmLocation
            : farmLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmingExperienceYears: freezed == farmingExperienceYears
            ? _value.farmingExperienceYears
            : farmingExperienceYears // ignore: cast_nullable_to_non_nullable
                  as int?,
        mainCommodity: freezed == mainCommodity
            ? _value.mainCommodity
            : mainCommodity // ignore: cast_nullable_to_non_nullable
                  as String?,
        farmingSystem: freezed == farmingSystem
            ? _value.farmingSystem
            : farmingSystem // ignore: cast_nullable_to_non_nullable
                  as String?,
        pondCount: freezed == pondCount
            ? _value.pondCount
            : pondCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalAreaSqm: freezed == totalAreaSqm
            ? _value.totalAreaSqm
            : totalAreaSqm // ignore: cast_nullable_to_non_nullable
                  as double?,
        buyerBusinessName: freezed == buyerBusinessName
            ? _value.buyerBusinessName
            : buyerBusinessName // ignore: cast_nullable_to_non_nullable
                  as String?,
        buyerBusinessType: freezed == buyerBusinessType
            ? _value.buyerBusinessType
            : buyerBusinessType // ignore: cast_nullable_to_non_nullable
                  as String?,
        buyerBusinessLocation: freezed == buyerBusinessLocation
            ? _value.buyerBusinessLocation
            : buyerBusinessLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        purchaseCapacityKgPerMonth: freezed == purchaseCapacityKgPerMonth
            ? _value.purchaseCapacityKgPerMonth
            : purchaseCapacityKgPerMonth // ignore: cast_nullable_to_non_nullable
                  as int?,
        interestedCommodities: null == interestedCommodities
            ? _value._interestedCommodities
            : interestedCommodities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        storeName: freezed == storeName
            ? _value.storeName
            : storeName // ignore: cast_nullable_to_non_nullable
                  as String?,
        storeLocation: freezed == storeLocation
            ? _value.storeLocation
            : storeLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        suppliedProducts: null == suppliedProducts
            ? _value._suppliedProducts
            : suppliedProducts // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isNewUser: null == isNewUser
            ? _value.isNewUser
            : isNewUser // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl with DiagnosticableTreeMixin implements _UserProfile {
  const _$UserProfileImpl({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    this.photoUrl,
    this.farmName,
    this.farmLocation,
    this.farmingExperienceYears,
    this.mainCommodity,
    this.farmingSystem,
    this.pondCount,
    this.totalAreaSqm,
    this.buyerBusinessName,
    this.buyerBusinessType,
    this.buyerBusinessLocation,
    this.purchaseCapacityKgPerMonth,
    final List<String> interestedCommodities = const [],
    this.storeName,
    this.storeLocation,
    final List<String> suppliedProducts = const [],
    this.isNewUser = true,
    this.createdAt,
    this.updatedAt,
  }) : _interestedCommodities = interestedCommodities,
       _suppliedProducts = suppliedProducts;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  // Informasi Wajib untuk SEMUA Peran
  // Mengganti 'id' menjadi 'uid' agar konsisten dengan Firebase Auth
  @override
  final String uid;
  @override
  final String email;
  // Mengganti 'name' menjadi 'fullName' agar lebih deskriptif
  @override
  final String fullName;
  @override
  final String phoneNumber;
  @override
  final UserRole role;
  // Mengganti 'avatarUrl' menjadi 'photoUrl' agar konsisten
  @override
  final String? photoUrl;
  // Informasi Spesifik Peternak (Farmer)
  @override
  final String? farmName;
  @override
  final String? farmLocation;
  @override
  final int? farmingExperienceYears;
  @override
  final String? mainCommodity;
  @override
  final String? farmingSystem;
  @override
  final int? pondCount;
  @override
  final double? totalAreaSqm;
  // Informasi Spesifik Pembeli (Buyer)
  @override
  final String? buyerBusinessName;
  @override
  final String? buyerBusinessType;
  @override
  final String? buyerBusinessLocation;
  @override
  final int? purchaseCapacityKgPerMonth;
  final List<String> _interestedCommodities;
  @override
  @JsonKey()
  List<String> get interestedCommodities {
    if (_interestedCommodities is EqualUnmodifiableListView)
      return _interestedCommodities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interestedCommodities);
  }

  // Informasi Spesifik Supplier
  @override
  final String? storeName;
  @override
  final String? storeLocation;
  final List<String> _suppliedProducts;
  @override
  @JsonKey()
  List<String> get suppliedProducts {
    if (_suppliedProducts is EqualUnmodifiableListView)
      return _suppliedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suppliedProducts);
  }

  // Metadata
  @override
  @JsonKey()
  final bool isNewUser;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserProfile(uid: $uid, email: $email, fullName: $fullName, phoneNumber: $phoneNumber, role: $role, photoUrl: $photoUrl, farmName: $farmName, farmLocation: $farmLocation, farmingExperienceYears: $farmingExperienceYears, mainCommodity: $mainCommodity, farmingSystem: $farmingSystem, pondCount: $pondCount, totalAreaSqm: $totalAreaSqm, buyerBusinessName: $buyerBusinessName, buyerBusinessType: $buyerBusinessType, buyerBusinessLocation: $buyerBusinessLocation, purchaseCapacityKgPerMonth: $purchaseCapacityKgPerMonth, interestedCommodities: $interestedCommodities, storeName: $storeName, storeLocation: $storeLocation, suppliedProducts: $suppliedProducts, isNewUser: $isNewUser, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserProfile'))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('fullName', fullName))
      ..add(DiagnosticsProperty('phoneNumber', phoneNumber))
      ..add(DiagnosticsProperty('role', role))
      ..add(DiagnosticsProperty('photoUrl', photoUrl))
      ..add(DiagnosticsProperty('farmName', farmName))
      ..add(DiagnosticsProperty('farmLocation', farmLocation))
      ..add(
        DiagnosticsProperty('farmingExperienceYears', farmingExperienceYears),
      )
      ..add(DiagnosticsProperty('mainCommodity', mainCommodity))
      ..add(DiagnosticsProperty('farmingSystem', farmingSystem))
      ..add(DiagnosticsProperty('pondCount', pondCount))
      ..add(DiagnosticsProperty('totalAreaSqm', totalAreaSqm))
      ..add(DiagnosticsProperty('buyerBusinessName', buyerBusinessName))
      ..add(DiagnosticsProperty('buyerBusinessType', buyerBusinessType))
      ..add(DiagnosticsProperty('buyerBusinessLocation', buyerBusinessLocation))
      ..add(
        DiagnosticsProperty(
          'purchaseCapacityKgPerMonth',
          purchaseCapacityKgPerMonth,
        ),
      )
      ..add(DiagnosticsProperty('interestedCommodities', interestedCommodities))
      ..add(DiagnosticsProperty('storeName', storeName))
      ..add(DiagnosticsProperty('storeLocation', storeLocation))
      ..add(DiagnosticsProperty('suppliedProducts', suppliedProducts))
      ..add(DiagnosticsProperty('isNewUser', isNewUser))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.farmName, farmName) ||
                other.farmName == farmName) &&
            (identical(other.farmLocation, farmLocation) ||
                other.farmLocation == farmLocation) &&
            (identical(other.farmingExperienceYears, farmingExperienceYears) ||
                other.farmingExperienceYears == farmingExperienceYears) &&
            (identical(other.mainCommodity, mainCommodity) ||
                other.mainCommodity == mainCommodity) &&
            (identical(other.farmingSystem, farmingSystem) ||
                other.farmingSystem == farmingSystem) &&
            (identical(other.pondCount, pondCount) ||
                other.pondCount == pondCount) &&
            (identical(other.totalAreaSqm, totalAreaSqm) ||
                other.totalAreaSqm == totalAreaSqm) &&
            (identical(other.buyerBusinessName, buyerBusinessName) ||
                other.buyerBusinessName == buyerBusinessName) &&
            (identical(other.buyerBusinessType, buyerBusinessType) ||
                other.buyerBusinessType == buyerBusinessType) &&
            (identical(other.buyerBusinessLocation, buyerBusinessLocation) ||
                other.buyerBusinessLocation == buyerBusinessLocation) &&
            (identical(
                  other.purchaseCapacityKgPerMonth,
                  purchaseCapacityKgPerMonth,
                ) ||
                other.purchaseCapacityKgPerMonth ==
                    purchaseCapacityKgPerMonth) &&
            const DeepCollectionEquality().equals(
              other._interestedCommodities,
              _interestedCommodities,
            ) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeLocation, storeLocation) ||
                other.storeLocation == storeLocation) &&
            const DeepCollectionEquality().equals(
              other._suppliedProducts,
              _suppliedProducts,
            ) &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    uid,
    email,
    fullName,
    phoneNumber,
    role,
    photoUrl,
    farmName,
    farmLocation,
    farmingExperienceYears,
    mainCommodity,
    farmingSystem,
    pondCount,
    totalAreaSqm,
    buyerBusinessName,
    buyerBusinessType,
    buyerBusinessLocation,
    purchaseCapacityKgPerMonth,
    const DeepCollectionEquality().hash(_interestedCommodities),
    storeName,
    storeLocation,
    const DeepCollectionEquality().hash(_suppliedProducts),
    isNewUser,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(this);
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile({
    required final String uid,
    required final String email,
    required final String fullName,
    required final String phoneNumber,
    required final UserRole role,
    final String? photoUrl,
    final String? farmName,
    final String? farmLocation,
    final int? farmingExperienceYears,
    final String? mainCommodity,
    final String? farmingSystem,
    final int? pondCount,
    final double? totalAreaSqm,
    final String? buyerBusinessName,
    final String? buyerBusinessType,
    final String? buyerBusinessLocation,
    final int? purchaseCapacityKgPerMonth,
    final List<String> interestedCommodities,
    final String? storeName,
    final String? storeLocation,
    final List<String> suppliedProducts,
    final bool isNewUser,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  // Informasi Wajib untuk SEMUA Peran
  // Mengganti 'id' menjadi 'uid' agar konsisten dengan Firebase Auth
  @override
  String get uid;
  @override
  String get email; // Mengganti 'name' menjadi 'fullName' agar lebih deskriptif
  @override
  String get fullName;
  @override
  String get phoneNumber;
  @override
  UserRole get role; // Mengganti 'avatarUrl' menjadi 'photoUrl' agar konsisten
  @override
  String? get photoUrl; // Informasi Spesifik Peternak (Farmer)
  @override
  String? get farmName;
  @override
  String? get farmLocation;
  @override
  int? get farmingExperienceYears;
  @override
  String? get mainCommodity;
  @override
  String? get farmingSystem;
  @override
  int? get pondCount;
  @override
  double? get totalAreaSqm; // Informasi Spesifik Pembeli (Buyer)
  @override
  String? get buyerBusinessName;
  @override
  String? get buyerBusinessType;
  @override
  String? get buyerBusinessLocation;
  @override
  int? get purchaseCapacityKgPerMonth;
  @override
  List<String> get interestedCommodities; // Informasi Spesifik Supplier
  @override
  String? get storeName;
  @override
  String? get storeLocation;
  @override
  List<String> get suppliedProducts; // Metadata
  @override
  bool get isNewUser;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
