// ===========================================================================
// DOMAIN LAYER
// Path: lib/features/forum/domain/models/forum_post.dart
// ===========================================================================
import 'package:equatable/equatable.dart';

/// Represents a single post in the forum.
/// Uses Equatable for efficient value comparison, crucial for state management.
/// All properties are final to ensure immutability.
class ForumPost extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  // final String? authorImageUrl; // Ready for future implementation
  final String title;
  final String content;
  final List<String> tags;
  final int likeCount;
  final int dislikeCount;
  final List<String> likedBy;
  final List<String> dislikedBy;
  final int replyCount;
  final DateTime createdAt;

  const ForumPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.tags,
    required this.likeCount,
    required this.dislikeCount,
    required this.likedBy,
    required this.dislikedBy,
    required this.replyCount,
    required this.createdAt,
  });

  /// Creates a copy of this ForumPost but with the given fields replaced with the new values.
  /// Essential for immutable state management.
  ForumPost copyWith({
    int? likeCount,
    int? dislikeCount,
    List<String>? likedBy,
    List<String>? dislikedBy,
    int? replyCount,
  }) {
    return ForumPost(
      id: id,
      authorId: authorId,
      authorName: authorName,
      title: title,
      content: content,
      tags: tags,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      likedBy: likedBy ?? this.likedBy,
      dislikedBy: dislikedBy ?? this.dislikedBy,
      replyCount: replyCount ?? this.replyCount,
      createdAt: createdAt,
    );
  }

  /// The list of properties that will be used to determine whether two instances are equal.
  @override
  List<Object?> get props => [
    id,
    authorId,
    likeCount,
    dislikeCount,
    likedBy,
    dislikedBy,
    replyCount,
  ];
}
