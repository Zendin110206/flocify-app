// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      photoUrl: json['photoUrl'] as String?,
      farmName: json['farmName'] as String?,
      farmLocation: json['farmLocation'] as String?,
      farmingExperienceYears: (json['farmingExperienceYears'] as num?)?.toInt(),
      mainCommodity: json['mainCommodity'] as String?,
      farmingSystem: json['farmingSystem'] as String?,
      pondCount: (json['pondCount'] as num?)?.toInt(),
      totalAreaSqm: (json['totalAreaSqm'] as num?)?.toDouble(),
      buyerBusinessName: json['buyerBusinessName'] as String?,
      buyerBusinessType: json['buyerBusinessType'] as String?,
      buyerBusinessLocation: json['buyerBusinessLocation'] as String?,
      purchaseCapacityKgPerMonth: (json['purchaseCapacityKgPerMonth'] as num?)
          ?.toInt(),
      interestedCommodities:
          (json['interestedCommodities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      storeName: json['storeName'] as String?,
      storeLocation: json['storeLocation'] as String?,
      suppliedProducts:
          (json['suppliedProducts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isNewUser: json['isNewUser'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'role': _$UserRoleEnumMap[instance.role]!,
      'photoUrl': instance.photoUrl,
      'farmName': instance.farmName,
      'farmLocation': instance.farmLocation,
      'farmingExperienceYears': instance.farmingExperienceYears,
      'mainCommodity': instance.mainCommodity,
      'farmingSystem': instance.farmingSystem,
      'pondCount': instance.pondCount,
      'totalAreaSqm': instance.totalAreaSqm,
      'buyerBusinessName': instance.buyerBusinessName,
      'buyerBusinessType': instance.buyerBusinessType,
      'buyerBusinessLocation': instance.buyerBusinessLocation,
      'purchaseCapacityKgPerMonth': instance.purchaseCapacityKgPerMonth,
      'interestedCommodities': instance.interestedCommodities,
      'storeName': instance.storeName,
      'storeLocation': instance.storeLocation,
      'suppliedProducts': instance.suppliedProducts,
      'isNewUser': instance.isNewUser,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.farmer: 'farmer',
  UserRole.buyer: 'buyer',
  UserRole.supplier: 'supplier',
  UserRole.unknown: 'unknown',
};
