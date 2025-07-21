// ===========================================================================
// DOMAIN LAYER
// Path: lib/features/forum/domain/repositories/forum_repository.dart
// ===========================================================================
import '../../../users/domain/models/user_profile.dart';
import '../models/forum_post.dart';
import '../models/forum_reply.dart';
import '../models/commodity.dart';

/// Abstract contract defining the data operations for the Forum feature.
/// This decouples the domain/presentation layers from the data source implementation.
abstract class ForumRepository {
  Future<List<ForumPost>> getPosts({
    required String filter,
    required String sortBy,
    required int page,
    required int limit,
  });

  Future<List<ForumReply>> getReplies({
    required String postId,
    String? parentReplyId,
    required int page,
    required int limit,
  });

  Future<ForumPost> getPostById(String id);

  Future<void> addPost({
    required String authorId,
    required String title,
    required String content,
    required List<String> tags,
  });

  /// Returns the newly created reply to enable optimistic UI updates.
  Future<ForumReply> addReply({
    required String authorId,
    required String postId,
    required String content,
    String? parentReplyId,
  });

  Future<void> votePost({
    required String postId,
    required String userId,
    required bool? isLike, // true=like, false=dislike, null=retract vote
  });

  Future<void> voteReply({
    required String replyId,
    required String userId,
    required bool? isLike,
  });

  /// Reports a post with a specific reason.
  Future<void> reportPost({
    required String postId,
    required String reason,
    String? details, // Untuk alasan "Lainnya"
  });

  Future<List<UserProfile>> searchUsersForMention({required String query});

  Future<List<Commodity>> getCommodities();
  Future<List<String>> getSuggestedTags();
}
