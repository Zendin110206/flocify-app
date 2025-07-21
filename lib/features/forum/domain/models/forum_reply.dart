// ===========================================================================
// DOMAIN LAYER
// Path: lib/features/forum/domain/models/forum_reply.dart
// ===========================================================================
import 'package:equatable/equatable.dart';

/// Represents a single reply to a forum post.
class ForumReply extends Equatable {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String content;
  final int likeCount;
  final int dislikeCount;
  final List<String> likedBy;
  final List<String> dislikedBy;
  final DateTime createdAt;
  final String? parentReplyId; // For nested replies

  const ForumReply({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.likeCount,
    required this.dislikeCount,
    required this.likedBy,
    required this.dislikedBy,
    required this.createdAt,
    this.parentReplyId,
  });

  ForumReply copyWith({
    int? likeCount,
    int? dislikeCount,
    List<String>? likedBy,
    List<String>? dislikedBy,
  }) {
    return ForumReply(
      id: id,
      postId: postId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      likedBy: likedBy ?? this.likedBy,
      dislikedBy: dislikedBy ?? this.dislikedBy,
      createdAt: createdAt,
      parentReplyId: parentReplyId,
    );
  }

  @override
  List<Object?> get props => [id, likeCount, dislikeCount, likedBy, dislikedBy];
}
