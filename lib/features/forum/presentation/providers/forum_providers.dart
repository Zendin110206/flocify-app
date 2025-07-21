// ===========================================================================
// PRESENTATION LAYER - PROVIDERS
// Path: lib/features/forum/presentation/providers/forum_providers.dart
// ===========================================================================
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/forum_repository_impl.dart';
import '../../domain/models/forum_post.dart';
import '../../domain/repositories/forum_repository.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart'; // <-- JANGAN LUPA IMPORT
import '../../domain/models/commodity.dart';
import '../../domain/usecases/vote_on_post_usecase.dart';

/// Provides the implementation of [ForumRepository].
/// This can be easily swapped with a real implementation (e.g., Firebase)
/// without affecting the rest of the application.
final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  return FakeForumRepository();
});

/// State providers for simple filter and sort options.
final forumFilterProvider = StateProvider.autoDispose<String>((ref) => 'Semua');
final forumSortByProvider = StateProvider.autoDispose<String>(
  (ref) => 'Terbaru',
);

/// Provider to fetch the list of commodities for filtering.
final commoditiesProvider = FutureProvider.autoDispose<List<Commodity>>((ref) {
  final repository = ref.watch(forumRepositoryProvider);
  return repository.getCommodities();
});

/// Provider to fetch suggested tags for post creation.
final suggestedTagsProvider = FutureProvider.autoDispose<List<String>>((ref) {
  final repository = ref.watch(forumRepositoryProvider);
  return repository.getSuggestedTags();
});

/// State class for the list of forum posts.
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

/// Notifier to manage the state of the forum posts list, including pagination and voting.
class ForumPostsNotifier extends StateNotifier<ForumPostsState> {
  final Ref _ref; // <-- 1. TAMBAHKAN BARIS INI
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
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
    }
    final originalPosts = state.posts;
    final postIndex = originalPosts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    // 1. Panggil UseCase untuk mendapatkan post yang sudah diperbarui
    final postToUpdate = originalPosts[postIndex];
    final updatedPost = VoteOnPostUseCase().execute(
      post: postToUpdate,
      userId: userId,
      isLike: isLike,
    );

    // 2. Lakukan optimistic UI update
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
    try {
      await _repository.votePost(
        postId: postId,
        userId: userId,
        isLike: finalVote,
      );
    } catch (e) {
      // Kembalikan ke state semula jika error
      state = state.copyWith(posts: originalPosts, errorMessage: e.toString());
    }
  }
}

/// The main provider for the list of forum posts.
/// It uses `.family` implicitly by watching other providers, so it will
/// automatically re-create itself when the filter or sort order changes.
final forumPostsProvider =
    StateNotifierProvider.autoDispose<ForumPostsNotifier, ForumPostsState>((
      ref,
    ) {
      final repository = ref.watch(forumRepositoryProvider);
      final filter = ref.watch(forumFilterProvider);
      final sortBy = ref.watch(forumSortByProvider);
      return ForumPostsNotifier(ref, repository, filter, sortBy);
    });

/// Provider to fetch the details of a single post.
/// More efficient than searching the list, as it fetches fresh data.
final postDetailProvider = FutureProvider.autoDispose.family<ForumPost, String>(
  (ref, postId) {
    final repository = ref.watch(forumRepositoryProvider);
    return repository.getPostById(postId);
  },
);
