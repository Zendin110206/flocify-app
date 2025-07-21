// lib/features/users/domain/models/user_profile.dart

class UserProfile {
  final String id;
  final String name;
  final String? avatarUrl; // Avatar bisa null

  UserProfile({required this.id, required this.name, this.avatarUrl});
}
