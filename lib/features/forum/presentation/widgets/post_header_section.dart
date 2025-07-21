// lib/features/forum/presentation/widgets/post_header_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/forum_providers.dart';

/// Section containing the "Post" title and the sort control.
class PostHeaderSection extends ConsumerWidget {
  const PostHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSort = ref.watch(forumSortByProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Post',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton.icon(
            onPressed: () {
              final newSort = selectedSort == 'Terbaru'
                  ? 'Terpopuler'
                  : 'Terbaru';
              ref.read(forumSortByProvider.notifier).state = newSort;
            },
            icon: const Icon(Icons.sort, size: 20),
            label: Text(selectedSort),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}
