// lib/features/forum/presentation/providers/create_post_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_state.freezed.dart';

@freezed
class CreatePostState with _$CreatePostState {
  const CreatePostState._(); // Constructor privat untuk getters

  const factory CreatePostState({
    @Default('') String title,
    String? titleError,
    @Default('') String content,
    String? contentError,
    @Default([]) List<String> tags,
    @Default(false) bool isSubmitting,
    String? successMessage,
    String? errorMessage,
    @Default(false) bool hasUnsavedChanges,
  }) = _CreatePostState;

  // Getters untuk kemudahan di UI
  bool get isFormValid =>
      titleError == null &&
      contentError == null &&
      title.isNotEmpty &&
      content.isNotEmpty;

  double get formCompletionProgress {
    double progress = 0.0;
    if (title.trim().length >= 15) progress += 0.4;
    if (content.trim().length >= 50) progress += 0.5;
    if (tags.isNotEmpty) progress += 0.1;
    return progress.clamp(0.0, 1.0);
  }

  String get formStatusMessage {
    if (titleError != null) return 'Perbaiki judul postingan';
    if (contentError != null) return 'Lengkapi detail konten';
    if (isFormValid) return 'Postingan siap dibagikan ke komunitas';
    return 'Lengkapi form untuk melanjutkan';
  }
}
