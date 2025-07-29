// Path: lib/features/forum/presentation/providers/reply_providers.dart (REVISI FINAL)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import '../../domain/models/forum_reply.dart';
import '../../domain/repositories/forum_repository.dart';
import 'forum_providers.dart';

// --- State & Notifier untuk Daftar Balasan ---

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

class ReplyNotifier extends StateNotifier<ReplyState> {
  final Ref _ref;
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

  Future<void> addReply(String content, {String? parentReplyId}) async {
    final previousReplies = state.replies;
    try {
      final authorId = _ref.read(currentUserIdProvider);

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

      state = state.copyWith(replies: [...previousReplies, tempReply]);

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
        errorMessage: e.toString().replaceFirst("Exception: ", ""),
      );
    }
  }

  Future<void> voteOnReply({
    required String replyId,
    required bool isLike,
  }) async {
    final originalReplies = state.replies;
    try {
      final userId = _ref.read(currentUserIdProvider);

      final replyIndex = originalReplies.indexWhere((r) => r.id == replyId);
      if (replyIndex == -1) return;

      final replyToUpdate = originalReplies[replyIndex];

      bool alreadyLiked = replyToUpdate.likedBy.contains(userId);
      bool alreadyDisliked = replyToUpdate.dislikedBy.contains(userId);
      int newLikeCount = replyToUpdate.likeCount;
      int newDislikeCount = replyToUpdate.dislikeCount;
      List<String> newLikedBy = List.from(replyToUpdate.likedBy);
      List<String> newDislikedBy = List.from(replyToUpdate.dislikedBy);
      bool? finalVote;

      if (isLike) {
        if (alreadyLiked) {
          newLikeCount--;
          newLikedBy.remove(userId);
          finalVote = null;
        } else {
          newLikeCount++;
          newLikedBy.add(userId);
          finalVote = true;
          if (alreadyDisliked) {
            newDislikeCount--;
            newDislikedBy.remove(userId);
          }
        }
      } else {
        if (alreadyDisliked) {
          newDislikeCount--;
          newDislikedBy.remove(userId);
          finalVote = null;
        } else {
          newDislikeCount++;
          newDislikedBy.add(userId);
          finalVote = false;
          if (alreadyLiked) {
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

      await _repository.voteReply(
        replyId: replyId,
        userId: userId,
        isLike: finalVote,
      );
    } catch (e) {
      state = state.copyWith(
        replies: originalReplies,
        errorMessage: e.toString().replaceFirst("Exception: ", ""),
      );
    }
  }
}

// --- Provider Utama ---

final replyProvider = StateNotifierProvider.autoDispose
    .family<ReplyNotifier, ReplyState, String>((ref, postId) {
      final repository = ref.watch(forumRepositoryProvider);
      return ReplyNotifier(ref, repository, postId);
    });
