// lib/features/forum/presentation/screens/create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/create_post_controller.dart';
import '../providers/create_post_state.dart';
import '../widgets/post_creation_bottom_action_bar.dart';
import '../widgets/post_creation_form.dart';
import '../widgets/post_creation_progress_header.dart';
import '../widgets/post_creation_welcome_card.dart';
import '../providers/forum_providers.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  static Route<void> route() => PageRouteBuilder(
    pageBuilder: (context, animation, _) => const CreatePostScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen>
    with TickerProviderStateMixin {
  // Controller dan Node tetap di sini karena terikat pada state layar
  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();
  final _tagsFocusNode = FocusNode();

  // Animasi juga dikelola oleh state layar
  late AnimationController _slideAnimationController;
  late AnimationController _submitAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _submitAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFormListeners();
  }

  void _initializeAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _submitAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _submitAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _submitAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _slideAnimationController.forward();
  }

  void _setupFormListeners() {}

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _submitAnimationController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _tagsFocusNode.dispose();
    super.dispose();
  }

  // Fungsi utilitas layar tetap di sini
  void _showAdvancedSnackBar(
    String message, {
    bool isError = false,
    SnackBarAction? action,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: action,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final state = ref.read(createPostControllerProvider);
    if (!state.hasUnsavedChanges) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simpan Perubahan?'),
        content: const Text(
          'Anda memiliki perubahan yang belum disimpan. Simpan sebagai draft?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Buang'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Lanjut Edit'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(createPostControllerProvider.notifier).saveAsDraft();
              Navigator.of(context).pop(true);
            },
            child: const Text('Simpan Draft'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _addSuggestedTag(String tag) {
    ref.read(createPostControllerProvider.notifier).addTag(tag);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(createPostControllerProvider.notifier);
    // 1. Ambil data suggestedTags dari provider
    final suggestedTagsAsync = ref.watch(suggestedTagsProvider);

    // Listener untuk side-effect (navigasi, snackbar, animasi)
    ref.listen<CreatePostState>(createPostControllerProvider, (previous, next) {
      // if (next.tags.join(', ') != _tagsC.text) {
      //   final newText = next.tags.join(', ');
      //   _tagsC.text = newText;
      //   _tagsC.selection = TextSelection.fromPosition(
      //     TextPosition(offset: newText.length),
      //   );
      // }
      if (next.successMessage != null) {
        _showAdvancedSnackBar(next.successMessage!);
        Navigator.of(context).pop(true);
        controller.clearMessages();
      }
      if (next.errorMessage != null) {
        _showAdvancedSnackBar(
          next.errorMessage!,
          isError: true,
          action: SnackBarAction(
            label: 'Coba Lagi',
            onPressed: controller.submitPost,
          ),
        );
        controller.clearMessages();
      }
      if (previous?.isSubmitting == true && next.isSubmitting == false) {
        _submitAnimationController.reverse();
      }
    });

    return PopScope(
      canPop: !ref.watch(createPostControllerProvider).hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        // ## PERBAIKAN 2: Mengamankan BuildContext ##
        // Simpan Navigator sebelum jeda async
        final navigator = Navigator.of(context);
        final shouldPop = await _onWillPop();

        if (shouldPop) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // SOLUSI: Tambahkan SizedBox di sini sebagai pendorong konten
            // Jaraknya adalah setinggi status bar + tinggi AppBar
            SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight,
            ),

            // Widget header (tanpa margin) akan pas di bawahnya
            const PostCreationProgressHeader(),

            Expanded(
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, 50 * (1 - _slideAnimation.value)),
                  child: Opacity(opacity: _slideAnimation.value, child: child),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const PostCreationWelcomeCard(),
                        const SizedBox(height: 24),

                        // 2. Gunakan .when() di sini
                        suggestedTagsAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => const Text('Gagal memuat tag'),
                          data: (suggestedTags) => PostCreationForm(
                            titleFocusNode: _titleFocusNode,
                            contentFocusNode: _contentFocusNode,
                            tagsFocusNode: _tagsFocusNode,
                            suggestedTags: suggestedTags,
                            onAddSuggestedTag: _addSuggestedTag,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            PostCreationBottomActionBar(
              submitAnimation: _submitAnimation,
              onSubmit: () {
                HapticFeedback.mediumImpact();
                _submitAnimationController.forward();
                controller.submitPost();
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final hasUnsavedChanges = ref.watch(
      createPostControllerProvider.select((s) => s.hasUnsavedChanges),
    );

    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(67, 144, 205, 255),
      foregroundColor: theme.colorScheme.onSurface,
      leading: IconButton(
        onPressed: () async {
          final navigator = Navigator.of(context);
          final shouldPop = await _onWillPop();
          if (shouldPop) {
            navigator.pop();
          }
        },
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      title: const Text(
        'Buat Postingan',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        if (hasUnsavedChanges)
          IconButton(
            onPressed: () {
              ref.read(createPostControllerProvider.notifier).saveAsDraft();
              _showAdvancedSnackBar('Draft berhasil disimpan');
            },
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: 'Simpan Draft',
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
