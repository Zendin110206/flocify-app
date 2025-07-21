// ===========================================================================
// PRESENTATION LAYER - SCREENS
// Path: lib/features/forum/presentation/screens/forum_screen.dart
//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/forum/presentation/providers/forum_providers.dart';
import 'package:proyek_flocify/features/forum/presentation/screens/create_post_screen.dart';
import 'package:proyek_flocify/features/forum/presentation/widgets/commodity_filter_section.dart';
import 'package:proyek_flocify/features/forum/presentation/widgets/forum_header.dart';
import 'package:proyek_flocify/features/forum/presentation/widgets/post_header_section.dart';
import 'package:proyek_flocify/features/forum/presentation/widgets/post_list_sliver.dart';

/// Halaman utama untuk fitur Forum.
///
/// DIUBAH menjadi ConsumerStatefulWidget untuk mengelola ScrollController.
class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});

  @override
  ConsumerState<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen> {
  // BARU: ScrollController dibuat di sini.
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // BARU: Listener untuk infinite scroll ditambahkan di sini.
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Logika yang sama seperti sebelumnya, sekarang berada di tempat yang tepat.
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(forumPostsProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    // BARU: Jangan lupa untuk membersihkan controller.
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FA),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(forumPostsProvider);
        },
        child: CustomScrollView(
          // BARU: Controller dipasang ke CustomScrollView.
          controller: _scrollController,
          slivers: const [
            SliverToBoxAdapter(child: ForumHeader()),
            SliverToBoxAdapter(child: CommodityFilterSection()),
            SliverToBoxAdapter(child: PostHeaderSection()),
            PostListSliver(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(CreatePostScreen.route()),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
