// lib/features/users/domain/models/user_profile.dart

// 1. Tambahkan import yang dibutuhkan untuk Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart'; // Dibutuhkan untuk @Default

// 2. Tambahkan part-part untuk file hasil generate
part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

// 3. Definisikan Enum untuk peran (Role)
enum UserRole {
  farmer,
  buyer,
  supplier,
  unknown, // Default role jika terjadi kesalahan
}

// 4. Definisikan model utama menggunakan @freezed
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    // Informasi Wajib untuk SEMUA Peran
    // Mengganti 'id' menjadi 'uid' agar konsisten dengan Firebase Auth
    required String uid,
    required String email,
    // Mengganti 'name' menjadi 'fullName' agar lebih deskriptif
    required String fullName,
    required String phoneNumber,
    required UserRole role,
    // Mengganti 'avatarUrl' menjadi 'photoUrl' agar konsisten
    String? photoUrl,

    // Informasi Spesifik Peternak (Farmer)
    String? farmName,
    String? farmLocation,
    int? farmingExperienceYears,
    String? mainCommodity,
    String? farmingSystem,
    int? pondCount,
    double? totalAreaSqm,

    // Informasi Spesifik Pembeli (Buyer)
    String? buyerBusinessName,
    String? buyerBusinessType,
    String? buyerBusinessLocation,
    int? purchaseCapacityKgPerMonth,
    @Default([]) List<String> interestedCommodities,

    // Informasi Spesifik Supplier
    String? storeName,
    String? storeLocation,
    @Default([]) List<String> suppliedProducts,

    // Metadata
    @Default(true) bool isNewUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  // Factory constructor untuk membuat instance dari JSON (data dari Firestore)
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
