import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/forum_reply.dart';
import '../providers/reply_providers.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import 'action_chip.dart';
import 'package:intl/intl.dart';

/// A card widget to display a single reply, with support for indentation.
class ReplyCard extends ConsumerWidget {
  final ForumReply reply;
  // DIUBAH: Menambahkan parameter indentationLevel
  final int indentationLevel;

  const ReplyCard({
    super.key,
    required this.reply,
    this.indentationLevel = 0, // Default ke 0 (tidak ada indentasi)
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final isLiked = reply.likedBy.contains(currentUserId);
    final isDisliked = reply.dislikedBy.contains(currentUserId);
    final theme = Theme.of(context);
    final bool isNestedReply = indentationLevel > 0;
    final Color cardBackgroundColor = isNestedReply
        ? Color.fromARGB(216, 255, 254, 253)
        : const Color.fromARGB(255, 255, 255, 255);

    // Widget untuk menampilkan dialog saat membalas
    void showReplyToReplyDialog() {
      final controller = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Balas kepada ${reply.authorName}'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Tulis balasan...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final content = controller.text.trim();
                if (content.isNotEmpty) {
                  ref
                      .read(replyProvider(reply.postId).notifier)
                      .addReply(content, parentReplyId: reply.id);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBackgroundColor, // <--- GUNAKAN VARIABEL YANG SUDAH DIBUAT
        borderRadius: BorderRadius.circular(12),
        // Kita gunakan border tipis, bukan shadow, untuk membedakan dari post utama
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 18,
                child: Icon(Icons.person, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply.authorName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // BARU: Menampilkan timestamp
                    Text(
                      DateFormat(
                        'd MMM yyyy, HH:mm',
                        'id_ID',
                      ).format(reply.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reply.content, style: const TextStyle(height: 1.4)),
                const SizedBox(height: 8),
                // BARU: Baris aksi yang menggunakan FlocifyActionChip
                Row(
                  children: [
                    FlocifyActionChip(
                      icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      label: '${reply.likeCount}',
                      color: isLiked ? theme.primaryColor : Colors.grey,
                      onTap: () => ref
                          .read(replyProvider(reply.postId).notifier)
                          .voteOnReply(replyId: reply.id, isLike: true),
                    ),
                    const SizedBox(width: 16),
                    // BARU: Menambahkan tombol Dislike
                    FlocifyActionChip(
                      icon: isDisliked
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined,
                      label: '${reply.dislikeCount}',
                      color: isDisliked ? Colors.red : Colors.grey,
                      onTap: () => ref
                          .read(replyProvider(reply.postId).notifier)
                          .voteOnReply(replyId: reply.id, isLike: false),
                    ),
                    const Spacer(),
                    // Tombol Balas (jika level indentasi masih 0)
                    if (indentationLevel == 0)
                      TextButton(
                        onPressed: showReplyToReplyDialog,
                        child: const Text('Balas'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
