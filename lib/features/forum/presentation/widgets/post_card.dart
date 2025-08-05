// lib/features/forum/presentation/widgets/post_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:proyek_flocify/features/forum/presentation/widgets/action_chip.dart';
import '../providers/forum_providers.dart';
import '../screens/post_detail_screen.dart';
import 'report_reason_sheet.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart'; // <-- JANGAN LUPA IMPORT

/// A card widget that displays a summary of a forum post.
/// It is highly optimized to only rebuild when its specific post data changes.
class PostCard extends ConsumerWidget {
  final String postId;
  const PostCard({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(
      forumPostsProvider.select(
        (state) => state.posts.firstWhere((p) => p.id == postId),
      ),
    );

    final currentUserId = ref.watch(currentUserIdProvider);
    final isLiked = post.likedBy.contains(currentUserId);
    final isDisliked = post.dislikedBy.contains(currentUserId);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: post.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20, // Sedikit diperbesar agar lebih seimbang
                  child: Icon(Icons.person, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat(
                          'd MMM yyyy',
                          'id_ID',
                        ).format(post.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // DIUBAH: Menggunakan Transform.translate untuk menggeser tombol ke atas
                Transform.translate(
                  offset: const Offset(8, -8), // Geser ke kanan & atas
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    iconSize: 20.0,
                    onSelected: (value) {
                      if (value == 'report') {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => ReportReasonSheet(postId: post.id),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'report',
                        child: ListTile(
                          leading: Icon(Icons.flag_outlined),
                          title: Text('Laporkan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
            const SizedBox(height: 12),
            // DIUBAH: Layout baris aksi diubah total
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
                  icon: isDisliked
                      ? Icons.thumb_down
                      : Icons.thumb_down_outlined,
                  label: '${post.dislikeCount}',
                  color: isDisliked ? Colors.red : Colors.grey,
                  onTap: () => ref
                      .read(forumPostsProvider.notifier)
                      .voteOnPost(postId: post.id, isLike: false),
                ),
                const Spacer(), // BARU: Mendorong sisa elemen ke kanan
                FlocifyActionChip(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.replyCount} Balasan',
                  color: Colors.grey,
                  onTap: () {
                    // Fungsi tap bisa ditambahkan di sini jika perlu
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
