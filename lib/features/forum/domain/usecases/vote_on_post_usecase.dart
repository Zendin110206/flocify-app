// Path: lib/features/forum/domain/usecases/vote_on_post_usecase.dart

import '../models/forum_post.dart';

/// Kelas ini bertanggung jawab HANYA untuk satu hal:
/// Menghitung status vote baru pada sebuah post.
class VoteOnPostUseCase {
  /// Mengembalikan `ForumPost` yang sudah diperbarui secara lokal.
  /// Ini adalah logika bisnis murni tanpa dependensi UI.
  ForumPost execute({
    required ForumPost post,
    required String userId,
    required bool isLike,
  }) {
    final bool alreadyLiked = post.likedBy.contains(userId);
    final bool alreadyDisliked = post.dislikedBy.contains(userId);

    int newLikeCount = post.likeCount;
    int newDislikeCount = post.dislikeCount;
    List<String> newLikedBy = List.from(post.likedBy);
    List<String> newDislikedBy = List.from(post.dislikedBy);

    if (isLike) {
      if (alreadyLiked) {
        // Batal menyukai
        newLikeCount--;
        newLikedBy.remove(userId);
      } else {
        // Menyukai post
        newLikeCount++;
        newLikedBy.add(userId);
        if (alreadyDisliked) {
          // Jika sebelumnya tidak suka, batalkan tidak suka
          newDislikeCount--;
          newDislikedBy.remove(userId);
        }
      }
    } else {
      // isDislike
      if (alreadyDisliked) {
        // Batal tidak suka
        newDislikeCount--;
        newDislikedBy.remove(userId);
      } else {
        // Tidak menyukai post
        newDislikeCount++;
        newDislikedBy.add(userId);
        if (alreadyLiked) {
          // Jika sebelumnya suka, batalkan suka
          newLikeCount--;
          newLikedBy.remove(userId);
        }
      }
    }

    return post.copyWith(
      likeCount: newLikeCount,
      dislikeCount: newDislikeCount,
      likedBy: newLikedBy,
      dislikedBy: newDislikedBy,
    );
  }
}
