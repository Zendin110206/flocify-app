// ===========================================================================
// PRESENTATION LAYER - PROVIDERS
// Path: lib/features/forum/presentation/providers/reply_providers.dart
// ===========================================================================
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/forum_reply.dart';
import '../../domain/repositories/forum_repository.dart';
import 'forum_providers.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart'; // <-- JANGAN LUPA IMPORT

/// State class for the list of replies.
class ReplyState {
  final List<ForumReply> replies;
  final bool isLoading;
  final bool hasReachedMax;
  final String? errorMessage;

  const ReplyState({
    this.replies = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  ReplyState copyWith({
    List<ForumReply>? replies,
    bool? isLoading,
    bool? hasReachedMax,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ReplyState(
      replies: replies ?? this.replies,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier to manage the state of replies for a specific post.
class ReplyNotifier extends StateNotifier<ReplyState> {
  final Ref _ref; // <-- 1. TAMBAHKAN INI
  final ForumRepository _repository;
  final String _postId;
  int _page = 1;
  static const int _limit = 15;

  ReplyNotifier(this._ref, this._repository, this._postId)
    : super(const ReplyState()) {
    fetchFirstPage();
  }

  Future<void> fetchFirstPage() async {
    state = const ReplyState(isLoading: true);
    _page = 1;
    try {
      final newReplies = await _repository.getReplies(
        postId: _postId,
        page: _page,
        limit: _limit,
      );
      state = state.copyWith(
        replies: newReplies,
        isLoading: false,
        hasReachedMax: newReplies.length < _limit,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Adds a reply with an optimistic UI update.
  Future<void> addReply(String content, {String? parentReplyId}) async {
    final authorId = _ref.read(currentUserIdProvider);
    if (authorId == null) {
      state = state.copyWith(errorMessage: 'Anda harus login untuk membalas.');
      return;
    }
    final tempReply = ForumReply(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      postId: _postId,
      authorId: authorId,
      authorName: 'Saya',
      content: content,
      likeCount: 0,
      dislikeCount: 0,
      likedBy: [],
      dislikedBy: [],
      createdAt: DateTime.now(),
      parentReplyId: parentReplyId,
    );

    final previousReplies = state.replies;
    state = state.copyWith(replies: [...previousReplies, tempReply]);

    try {
      final realReply = await _repository.addReply(
        authorId: authorId,
        postId: _postId,
        content: content,
        parentReplyId: parentReplyId,
      );

      final finalReplies = List<ForumReply>.from(state.replies);
      final tempIndex = finalReplies.indexWhere((r) => r.id == tempReply.id);
      if (tempIndex != -1) {
        finalReplies[tempIndex] = realReply;
        state = state.copyWith(replies: finalReplies);
      }
    } catch (e) {
      state = state.copyWith(
        replies: previousReplies,
        errorMessage: e.toString(),
      );
    }
  }

  // TAMBAHKAN METHOD BARU INI
  Future<void> voteOnReply({
    required String replyId,
    required bool isLike,
  }) async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      throw Exception('Anda harus login untuk memberikan vote.');
    }

    // Optimistic UI update
    final originalReplies = state.replies;
    final replyIndex = originalReplies.indexWhere((r) => r.id == replyId);
    if (replyIndex == -1) return;

    final replyToUpdate = originalReplies[replyIndex];

    // Logika untuk menangani like/dislike/retract (sama seperti di post)
    bool alreadyLiked = replyToUpdate.likedBy.contains(userId);
    bool alreadyDisliked = replyToUpdate.dislikedBy.contains(userId);
    int newLikeCount = replyToUpdate.likeCount;
    int newDislikeCount = replyToUpdate.dislikeCount;
    List<String> newLikedBy = List.from(replyToUpdate.likedBy);
    List<String> newDislikedBy = List.from(replyToUpdate.dislikedBy);
    bool? finalVote;

    if (isLike) {
      if (alreadyLiked) {
        // Retract like
        newLikeCount--;
        newLikedBy.remove(userId);
        finalVote = null;
      } else {
        // Add like
        newLikeCount++;
        newLikedBy.add(userId);
        finalVote = true;
        if (alreadyDisliked) {
          // Remove dislike if exists
          newDislikeCount--;
          newDislikedBy.remove(userId);
        }
      }
    } else {
      // Is dislike
      if (alreadyDisliked) {
        // Retract dislike
        newDislikeCount--;
        newDislikedBy.remove(userId);
        finalVote = null;
      } else {
        // Add dislike
        newDislikeCount++;
        newDislikedBy.add(userId);
        finalVote = false;
        if (alreadyLiked) {
          // Remove like if exists
          newLikeCount--;
          newLikedBy.remove(userId);
        }
      }
    }

    final updatedReply = replyToUpdate.copyWith(
      likeCount: newLikeCount,
      dislikeCount: newDislikeCount,
      likedBy: newLikedBy,
      dislikedBy: newDislikedBy,
    );

    final newReplies = List<ForumReply>.from(originalReplies);
    newReplies[replyIndex] = updatedReply;
    state = state.copyWith(replies: newReplies);

    // Call repository
    try {
      await _repository.voteReply(
        replyId: replyId,
        userId: userId,
        isLike: finalVote,
      );
    } catch (e) {
      // Rollback on error
      state = state.copyWith(
        replies: originalReplies,
        errorMessage: e.toString(),
      );
    }
  }

  // Note: voteOnReply logic is omitted for brevity but would be identical to voteOnPost.
}

/// Provider for replies, using `.family` to create a unique notifier for each post ID.
final replyProvider = StateNotifierProvider.autoDispose
    .family<ReplyNotifier, ReplyState, String>((ref, postId) {
      // <-- ref sudah ada
      final repository = ref.watch(forumRepositoryProvider);
      // 3. MASUKKAN ref SAAT MEMBUAT NOTIFIER
      return ReplyNotifier(ref, repository, postId);
    });
