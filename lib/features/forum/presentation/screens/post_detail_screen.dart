import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import '../../domain/models/forum_post.dart';
import '../../domain/models/forum_reply.dart';
import '../providers/forum_providers.dart';
import '../providers/reply_providers.dart';
import '../widgets/reply_card.dart';
import '../widgets/action_chip.dart';

/// Displays the full content of a single post and its replies.
class PostDetailScreen extends ConsumerWidget {
  final String postId;
  final scaffoldBackgroundColor = const Color.fromARGB(255, 244, 242, 242);

  PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(postId));

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,

      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (post) {
          // BARU: Seluruh layar dibungkus Column.
          return Column(
            children: [
              // BARU: Konten yang bisa di-scroll dibungkus Expanded.
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // --- BAGIAN HEADER (SliverAppBar) ---
                    SliverAppBar(
                      pinned: false,
                      floating: true,
                      snap: true,
                      stretch: true,
                      backgroundColor: Color(0xFFE7F1FF),
                      title: const Text('Postingan'),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Color.fromARGB(223, 243, 248, 255),
                              ],
                              stops: [0.0, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // --- BAGIAN KONTEN UTAMA (DALAM KARTU) ---
                    SliverToBoxAdapter(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: _buildPostContent(context, ref, post),
                        ),
                      ),
                    ),
                    // --- BAGIAN HEADER BALASAN ---
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Balasan (${post.replyCount})',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- BAGIAN DAFTAR BALASAN ---
                    _ReplyListSliver(postId: postId),

                    // Jarak aman di bawah
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),

              // BARU: _ReplyInputBox dipindahkan ke sini.
              _ReplyInputBox(postId: postId),
            ],
          );
        },
      ),
    );
  }

  /// Helper widget untuk membangun konten post utama agar build method utama bersih.
  Widget _buildPostContent(
    BuildContext context,
    WidgetRef ref,
    ForumPost post,
  ) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final isLiked = post.likedBy.contains(currentUserId);
    final isDisliked = post.dislikedBy.contains(currentUserId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(
            post.authorName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(post.createdAt),
          ),
        ),

        Text(
          post.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          post.content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: post.tags.map((tag) {
            return ActionChip(
              label: Text(tag, style: TextStyle(color: Colors.blue.shade50)),
              backgroundColor: Colors.blue,
              onPressed: () {
                // nanti implement filter berdasarkan tag
              },
            );
          }).toList(),
        ),

        const Divider(height: 32),
        Row(
          children: [
            FlocifyActionChip(
              icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
              label: '${post.likeCount}',
              color: isLiked ? Theme.of(context).primaryColor : Colors.grey,
              onTap: () => ref
                  .read(forumPostsProvider.notifier)
                  .voteOnPost(postId: post.id, isLike: true),
            ),
            const SizedBox(width: 16),
            FlocifyActionChip(
              icon: isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
              label: '${post.dislikeCount}',
              color: isDisliked ? Colors.red : Colors.grey,
              onTap: () => ref
                  .read(forumPostsProvider.notifier)
                  .voteOnPost(postId: post.id, isLike: false),
            ),
            const Spacer(),
            FlocifyActionChip(
              icon: Icons.chat_bubble_outline,
              label: '${post.replyCount} Balasan',
              color: Colors.grey,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

/// A Sliver widget to display replies with proper nesting.
class _ReplyListSliver extends ConsumerWidget {
  final String postId;
  const _ReplyListSliver({required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replyState = ref.watch(replyProvider(postId));

    if (replyState.isLoading && replyState.replies.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (replyState.replies.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Jadilah yang pertama membalas.'),
          ),
        ),
      );
    }

    final allReplies = replyState.replies;
    final topLevelReplies = allReplies
        .where((r) => r.parentReplyId == null)
        .toList();
    final childRepliesMap = <String, List<ForumReply>>{};

    for (final reply in allReplies) {
      if (reply.parentReplyId != null) {
        childRepliesMap.putIfAbsent(reply.parentReplyId!, () => []).add(reply);
      }
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final topLevelReply = topLevelReplies[index];
        final children = childRepliesMap[topLevelReply.id] ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              ReplyCard(reply: topLevelReply, indentationLevel: 0),
              Divider(height: 1, color: Colors.grey.shade300),

              if (children.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 8.0,
                  ), // Padding untuk seluruh grup balasan
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- GARIS VERTIKAL ---
                      Container(
                        width: 2,
                        margin: const EdgeInsets.only(right: 12.0, top: 12.0),
                        height:
                            60, // Sesuaikan tinggi atau biarkan kosong agar dinamis
                        color: Colors.grey.shade300,
                      ),
                      // --- KOLOM BALASAN BERTINGKAT ---
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children
                              .map(
                                (childReply) => Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ReplyCard(
                                    reply: childReply,
                                    indentationLevel:
                                        1, // Tetap gunakan ini untuk logika internal
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }, childCount: topLevelReplies.length),
    );
  }
}

/// The input box at the bottom, with improved styling.
class _ReplyInputBox extends ConsumerStatefulWidget {
  final String postId;
  const _ReplyInputBox({required this.postId});

  @override
  ConsumerState<_ReplyInputBox> createState() => _ReplyInputBoxState();
}

class _ReplyInputBoxState extends ConsumerState<_ReplyInputBox> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitReply() {
    final content = _controller.text.trim();
    if (content.isNotEmpty) {
      ref.read(replyProvider(widget.postId).notifier).addReply(content);
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        12,
        12,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Tulis balasan Anda...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _submitReply,
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
