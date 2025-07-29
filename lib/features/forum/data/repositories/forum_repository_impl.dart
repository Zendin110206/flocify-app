// ===========================================================================
// DATA LAYER
// Path: lib/features/forum/data/repositories/forum_repository_impl.dart
// ===========================================================================
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import '../../domain/models/forum_post.dart';
import '../../domain/models/forum_reply.dart';
import '../../domain/repositories/forum_repository.dart';
import '../../domain/models/commodity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart'
    show UserRole;

/// A fake implementation of [ForumRepository] for UI development and testing.
/// This class simulates network latency and returns dummy data.
///
/// ! IMPORTANT: Logic like filtering, sorting, and pagination should exist on the
/// ! backend in a real application. This implementation is intentionally kept
/// ! simple to mimic a client requesting data from a server.
class FakeForumRepository implements ForumRepository {
  // Dummy data is now encapsulated and private.
  final List<ForumPost> _dummyPosts = [
    ForumPost(
      id: 'post001',
      authorId: 'user123',
      authorName: 'Aceng',
      title: 'Cara menggabungkan Bioflok dan RAS',
      content:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum velit id dui. ',
      tags: ['Bioflok', 'RAS', 'Nila'],
      likeCount: 120,
      dislikeCount: 5,
      likedBy: List.generate(120, (i) => 'user$i'),
      dislikedBy: ['user_x', 'user_y'],
      replyCount: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ForumPost(
      id: 'post002',
      authorId: 'user456',
      authorName: 'Budi',
      title: 'Tips Pakan Udang Vaname agar Cepat Besar',
      content:
          'Aenean faucibus metus urna, vel tincidunt purus consequat vel. Proin et commodo dolor. Proin et commodo dolor.',
      tags: ['Udang', 'Pakan'],
      likeCount: 95,
      dislikeCount: 2,
      likedBy: List.generate(95, (i) => 'user$i'),
      dislikedBy: [],
      replyCount: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    // Add more dummy data for pagination testing
    ...List.generate(
      20,
      (index) => ForumPost(
        id: 'post${100 + index}',
        authorId: 'user_gen_$index',
        authorName: 'Pengguna ${index + 4}',
        title: 'Topik Tambahan #${index + 1} Tentang Akuakultur',
        content:
            'Ini adalah konten untuk postingan tambahan agar daftar menjadi panjang dan bisa di-scroll.',
        tags: ['Test', 'Pagination'],
        likeCount: 10 + index * 5,
        dislikeCount: index % 3,
        likedBy: [],
        dislikedBy: [],
        replyCount: 0,
        createdAt: DateTime.now().subtract(Duration(days: 2 + index)),
      ),
    ),
  ];

  @override
  Future<List<Commodity>> getCommodities() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      Commodity(
        name: 'Semua',
        postCount: 450,
        iconData: FontAwesomeIcons.water,
      ),
      Commodity(name: 'Nila', postCount: 120, iconData: FontAwesomeIcons.fish),
      Commodity(
        name: 'Udang',
        postCount: 97,
        iconData: FontAwesomeIcons.shrimp,
      ),
      Commodity(name: 'Lele', postCount: 190, iconData: FontAwesomeIcons.fish),
    ];
  }

  @override
  Future<List<String>> getSuggestedTags() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulasi network
    return [
      'lele',
      'nila',
      'gurame',
      'patin',
      'udang',
      'biofloc',
      'kolam terpal',
      'aerasi',
      'pakan',
      'pemula',
      'tips',
      'masalah',
      'penyakit',
    ];
  }

  final List<ForumReply> _dummyReplies = [
    ForumReply(
      id: 'reply001',
      postId: 'post001',
      authorId: 'user456',
      authorName: 'Budi',
      content:
          'Wah, ide bagus! Saya pernah coba tapi gagal di aerasi. Ada tips?',
      likeCount: 15,
      dislikeCount: 0,
      likedBy: [],
      dislikedBy: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      parentReplyId: null,
    ),
    ForumReply(
      id: 'reply002',
      postId: 'post001',
      authorId: 'user123',
      authorName: 'Aceng',
      content:
          'Pastikan pakai aerator yang dayanya sesuai volume air, Pak Budi.',
      likeCount: 10,
      dislikeCount: 0,
      likedBy: [],
      dislikedBy: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      parentReplyId: 'reply001',
    ),
    ForumReply(
      id: 'reply003',
      postId: 'post001',
      authorId: 'user789',
      authorName: 'Siti',
      content:
          'Setuju dengan Aceng. Jangan lupa juga perhatikan kedalaman kolam.',
      likeCount: 8,
      dislikeCount: 1,
      likedBy: [],
      dislikedBy: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      parentReplyId: null,
    ),
  ];

  @override
  Future<List<ForumPost>> getPosts({
    required String filter,
    required String sortBy,
    required int page,
    required int limit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    List<ForumPost> result = List.from(_dummyPosts);
    if (filter != 'Semua') {
      result = _dummyPosts
          .where(
            (post) => post.tags.any(
              (tag) => tag.toLowerCase() == filter.toLowerCase(),
            ),
          )
          .toList();
    }
    if (sortBy == 'Terbaru') {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortBy == 'Terpopuler') {
      result.sort((a, b) => b.likeCount.compareTo(a.likeCount));
    }

    final startIndex = (page - 1) * limit;
    if (startIndex >= result.length) return [];
    final endIndex = (startIndex + limit > result.length)
        ? result.length
        : startIndex + limit;
    return result.sublist(startIndex, endIndex);
  }

  @override
  Future<ForumPost> getPostById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummyPosts.firstWhere(
      (post) => post.id == id,
      orElse: () => throw Exception('Post tidak ditemukan!'),
    );
  }

  @override
  Future<List<ForumReply>> getReplies({
    required String postId,
    String? parentReplyId,
    required int page,
    required int limit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final filteredReplies = _dummyReplies
        .where(
          (reply) =>
              reply.postId == postId && reply.parentReplyId == parentReplyId,
        )
        .toList();
    final startIndex = (page - 1) * limit;
    if (startIndex >= filteredReplies.length) return [];
    final endIndex = (startIndex + limit > filteredReplies.length)
        ? filteredReplies.length
        : startIndex + limit;
    return filteredReplies.sublist(startIndex, endIndex);
  }

  @override
  Future<void> addPost({
    required String authorId,
    required String title,
    required String content,
    required List<String> tags,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final newPost = ForumPost(
      id: 'post${DateTime.now().millisecondsSinceEpoch}',
      authorId: authorId,
      authorName: 'User Baru',
      title: title,
      content: content,
      tags: tags,
      likeCount: 0,
      dislikeCount: 0,
      likedBy: [],
      dislikedBy: [],
      replyCount: 0,
      createdAt: DateTime.now(),
    );
    _dummyPosts.insert(0, newPost);
  }

  @override
  Future<ForumReply> addReply({
    required String authorId,
    required String postId,
    required String content,
    String? parentReplyId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final newReply = ForumReply(
      id: 'reply${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      authorId: authorId,
      authorName: 'User Balas',
      content: content,
      likeCount: 0,
      dislikeCount: 0,
      likedBy: [],
      dislikedBy: [],
      createdAt: DateTime.now(),
      parentReplyId: parentReplyId,
    );
    _dummyReplies.add(newReply);
    return newReply;
  }

  @override
  Future<void> votePost({
    required String postId,
    required String userId,
    required bool? isLike,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('SUCCESS: User $userId vote pada post $postId (isLike: $isLike)');
  }

  @override
  Future<void> voteReply({
    required String replyId,
    required String userId,
    required bool? isLike,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('SUCCESS: User $userId vote pada balasan $replyId (isLike: $isLike)');
  }

  // KODE BARU YANG SUDAH DIPERBAIKI
  @override
  Future<List<UserProfile>> searchUsersForMention({
    required String query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return [];

    // Buat data dummy yang sesuai dengan model UserProfile BARU
    final dummyUsers = [
      UserProfile(
        uid: 'user123',
        fullName: 'Aceng',
        email: 'aceng@mail.com',
        phoneNumber: '123',
        role: UserRole.farmer,
      ),
      UserProfile(
        uid: 'user456',
        fullName: 'Budi',
        email: 'budi@mail.com',
        phoneNumber: '456',
        role: UserRole.buyer,
      ),
      UserProfile(
        uid: 'user789',
        fullName: 'Siti',
        email: 'siti@mail.com',
        phoneNumber: '789',
        role: UserRole.supplier,
      ),
    ];

    // Gunakan field 'fullName' yang baru untuk filtering
    return dummyUsers
        .where(
          (user) => user.fullName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<void> reportPost({
    required String postId,
    required String reason,
    String? details,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi network
    print('SUCCESS: Post $postId reported. Reason: $reason, Details: $details');
    // Di backend asli, di sinilah data laporan disimpan.
  }
}
