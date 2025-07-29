// lib/features/forum/presentation/providers/create_post_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_post_state.dart';
import 'forum_providers.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart'; // <-- JANGAN LUPA IMPORT

final createPostControllerProvider =
    StateNotifierProvider.autoDispose<CreatePostController, CreatePostState>((
      ref,
    ) {
      return CreatePostController(ref);
    });

class CreatePostController extends StateNotifier<CreatePostState> {
  final Ref _ref;
  CreatePostController(this._ref) : super(const CreatePostState());

  void onTitleChanged(String title) {
    state = state.copyWith(
      title: title,
      titleError: _validateTitle(title),
      hasUnsavedChanges: true,
    );
  }

  void onContentChanged(String content) {
    state = state.copyWith(
      content: content,
      contentError: _validateContent(content),
      hasUnsavedChanges: true,
    );
  }

  void onTagsChanged(String text) {
    final tags = text
        .split(',')
        .map((t) => t.trim().toLowerCase())
        .where((t) => t.isNotEmpty && t != ' ')
        .toSet() // Gunakan Set untuk menghilangkan duplikat secara otomatis
        .toList();

    if (tags.length > 8) {
      // Batasi hingga 8 tag jika pengguna mengetik lebih
      tags.removeRange(8, tags.length);
    }

    state = state.copyWith(tags: tags, hasUnsavedChanges: true);
  }

  String addTag(String tag) {
    if (state.tags.contains(tag) || state.tags.length >= 8) {
      return state.tags.join(
        ', ',
      ); // Kembalikan teks yang ada jika tag sudah ada/penuh
    }

    final newTags = List<String>.from(state.tags)..add(tag);
    state = state.copyWith(tags: newTags, hasUnsavedChanges: true);

    // Kembalikan string tag yang sudah digabungkan
    return newTags.join(', ');
  }

  String removeTag(String tag) {
    final newTags = List<String>.from(state.tags)..remove(tag);
    state = state.copyWith(tags: newTags, hasUnsavedChanges: true);

    return newTags.join(', ');
  }

  void saveAsDraft() {
    // TODO: Nanti kita implementasi simpan ke database lokal di sini.
    // Untuk sekarang, kita anggap berhasil dan reset status perubahannya.
    print('DRAFT SAVED: ${state.title}');
    state = state.copyWith(hasUnsavedChanges: false);
  }

  void clearMessages() {
    // Reset pesan agar SnackBar tidak muncul lagi saat rebuild.
    state = state.copyWith(successMessage: null, errorMessage: null);
  }

  Future<void> submitPost() async {
    // Jalankan validasi terakhir sebelum submit
    final titleError = _validateTitle(state.title);
    final contentError = _validateContent(state.content);
    state = state.copyWith(titleError: titleError, contentError: contentError);

    if (!state.isFormValid || state.isSubmitting) return;

    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final repository = _ref.read(forumRepositoryProvider);
      final authorId = _ref.read(currentUserIdProvider);

      await repository.addPost(
        authorId: authorId,
        title: state.title.trim(),
        content: state.content.trim(),
        tags: state.tags,
      );
      state = state.copyWith(
        isSubmitting: false,
        successMessage: "Postingan berhasil dibuat!",
      );
      _ref.invalidate(forumPostsProvider);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
    }
  }

  // --- Logika Validasi ---
  String? _validateTitle(String value) {
    if (value.trim().isEmpty) return 'Judul wajib diisi';
    if (value.trim().length < 15) return 'Judul minimal 15 karakter';
    if (value.trim().length > 120) return 'Judul maksimal 120 karakter';
    return null;
  }

  String? _validateContent(String value) {
    if (value.trim().isEmpty) return 'Konten wajib diisi';
    if (value.trim().length < 50) return 'Konten minimal 50 karakter';
    return null;
  }
}
