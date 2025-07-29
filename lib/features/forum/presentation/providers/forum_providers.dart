// Path: lib/features/forum/presentation/providers/forum_providers.dart (REVISI FINAL)

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/forum_repository_impl.dart';
import '../../domain/models/commodity.dart';
import '../../domain/models/forum_post.dart';
import '../../domain/repositories/forum_repository.dart';
import '../../domain/usecases/vote_on_post_usecase.dart';

// --- Providers Lapisan Data & Opsi UI ---

final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  return FakeForumRepository();
});

final forumFilterProvider = StateProvider.autoDispose<String>((ref) => 'Semua');
final forumSortByProvider = StateProvider.autoDispose<String>(
  (ref) => 'Terbaru',
);

final commoditiesProvider = FutureProvider.autoDispose<List<Commodity>>((ref) {
  return ref.watch(forumRepositoryProvider).getCommodities();
});

final suggestedTagsProvider = FutureProvider.autoDispose<List<String>>((ref) {
  return ref.watch(forumRepositoryProvider).getSuggestedTags();
});

// --- State & Notifier untuk Daftar Postingan Forum ---

class ForumPostsState {
  final List<ForumPost> posts;
  final bool isLoading;
  final bool hasReachedMax;
  final String? errorMessage;

  const ForumPostsState({
    this.posts = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  ForumPostsState copyWith({
    List<ForumPost>? posts,
    bool? isLoading,
    bool? hasReachedMax,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ForumPostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class ForumPostsNotifier extends StateNotifier<ForumPostsState> {
  final Ref _ref;
  final ForumRepository _repository;
  final String _filter;
  final String _sortBy;
  int _page = 1;
  static const int _limit = 10;

  ForumPostsNotifier(this._ref, this._repository, this._filter, this._sortBy)
    : super(const ForumPostsState()) {
    fetchFirstPage();
  }

  Future<void> fetchFirstPage() async {
    if (state.isLoading) return;
    state = const ForumPostsState(isLoading: true);
    _page = 1;
    try {
      final posts = await _repository.getPosts(
        filter: _filter,
        sortBy: _sortBy,
        page: _page,
        limit: _limit,
      );
      state = state.copyWith(
        posts: posts,
        isLoading: false,
        hasReachedMax: posts.length < _limit,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchNextPage() async {
    if (state.hasReachedMax || state.isLoading) return;
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    _page++;
    try {
      final newPosts = await _repository.getPosts(
        filter: _filter,
        sortBy: _sortBy,
        page: _page,
        limit: _limit,
      );
      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        isLoading: false,
        hasReachedMax: newPosts.length < _limit,
      );
    } catch (e) {
      _page--;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> voteOnPost({
    required String postId,
    required bool isLike,
  }) async {
    // Simpan state asli untuk rollback jika terjadi error
    final originalPosts = state.posts;

    try {
      // 1. Dapatkan ID pengguna. Ini akan throw error jika user tidak login.
      final userId = _ref.read(currentUserIdProvider);

      final postIndex = originalPosts.indexWhere((p) => p.id == postId);
      if (postIndex == -1) return;

      // 2. Lakukan optimistic UI update
      final postToUpdate = originalPosts[postIndex];
      final updatedPost = VoteOnPostUseCase().execute(
        post: postToUpdate,
        userId: userId,
        isLike: isLike,
      );
      final newPosts = List<ForumPost>.from(originalPosts);
      newPosts[postIndex] = updatedPost;
      state = state.copyWith(posts: newPosts);

      // 3. Tentukan vote final untuk dikirim ke repository
      bool? finalVote;
      if (updatedPost.likedBy.contains(userId)) {
        finalVote = true;
      } else if (updatedPost.dislikedBy.contains(userId)) {
        finalVote = false;
      } else {
        finalVote = null; // Batal vote
      }

      // 4. Kirim ke repository
      await _repository.votePost(
        postId: postId,
        userId: userId,
        isLike: finalVote,
      );
    } catch (e) {
      // Jika terjadi error (entah dari currentUserIdProvider atau repository),
      // kembalikan state ke semula dan tampilkan pesan error.
      state = state.copyWith(
        posts: originalPosts,
        errorMessage: e.toString().replaceFirst("Exception: ", ""),
      );
    }
  }
}

// --- Providers Utama ---

final forumPostsProvider =
    StateNotifierProvider.autoDispose<ForumPostsNotifier, ForumPostsState>((
      ref,
    ) {
      final repository = ref.watch(forumRepositoryProvider);
      final filter = ref.watch(forumFilterProvider);
      final sortBy = ref.watch(forumSortByProvider);
      return ForumPostsNotifier(ref, repository, filter, sortBy);
    });

final postDetailProvider = FutureProvider.autoDispose.family<ForumPost, String>(
  (ref, postId) {
    final repository = ref.watch(forumRepositoryProvider);
    return repository.getPostById(postId);
  },
);
