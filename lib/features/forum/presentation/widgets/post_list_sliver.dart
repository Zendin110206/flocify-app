// lib/features/forum/presentation/widgets/post_list_sliver.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/forum/presentation/providers/forum_providers.dart';
import 'package:proyek_flocify/features/forum/presentation/widgets/post_card.dart';

/// A Sliver widget that displays the list of posts with infinite scroll.
class PostListSliver extends ConsumerWidget {
  const PostListSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forumPostsProvider);

    // --- Menangani berbagai state UI ---

    if (state.posts.isEmpty && state.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.posts.isEmpty && state.errorMessage != null) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Terjadi kesalahan: ${state.errorMessage}'),
          ),
        ),
      );
    }

    if (state.posts.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Belum ada postingan untuk komoditas ini.'),
          ),
        ),
      );
    }

    // --- State: Sukses, tampilkan list ---

    // DIKEMBALIKAN: Menggunakan SliverList biasa dan padding hanya di bawah.
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 80.0), // Padding hanya untuk FAB
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Tampilkan loading indicator di akhir list
            if (index >= state.posts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final post = state.posts[index];
            // PostCard akan mengatur margin-nya sendiri
            return PostCard(postId: post.id);
          },
          // Tambah 1 item jika sedang loading halaman berikutnya
          childCount:
              state.posts.length +
              (state.isLoading && state.posts.isNotEmpty ? 1 : 0),
        ),
      ),
    );
  }
}
