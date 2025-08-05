// lib/features/home/tab/forum/presentation/widgets/post_creation_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/create_post_controller.dart';
import '../providers/create_post_state.dart';

class PostCreationForm extends ConsumerWidget {
  final FocusNode titleFocusNode;
  final FocusNode contentFocusNode;
  final FocusNode tagsFocusNode;
  final List<String> suggestedTags;
  final Function(String) onAddSuggestedTag;

  const PostCreationForm({
    super.key,
    required this.titleFocusNode,
    required this.contentFocusNode,
    required this.tagsFocusNode,
    required this.suggestedTags,
    required this.onAddSuggestedTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(createPostControllerProvider);

    return Column(
      children: [
        _buildEnhancedTitleField(theme, state, ref),
        const SizedBox(height: 28),
        _buildEnhancedContentField(theme, state, ref),
        const SizedBox(height: 28),
        _buildEnhancedTagsSection(context, theme, ref, state),
      ],
    );
  }

  Widget _buildEnhancedTitleField(
    ThemeData theme,
    CreatePostState state,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Judul Postingan',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: state.title.length >= 15
                    ? const Color(0xFF00E676).withAlpha((0.1 * 255).round())
                    : theme.colorScheme.outline.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.title.length >= 15
                      ? const Color(0xFF00E676)
                      : theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Text(
                '${state.title.length}/120',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: state.title.length >= 15
                      ? const Color(0xFF00B347)
                      : theme.colorScheme.onSurface.withAlpha(
                          (0.6 * 255).round(),
                        ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha((0.05 * 255).round()),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: state.title,
            onChanged: (value) => ref
                .read(createPostControllerProvider.notifier)
                .onTitleChanged(value),
            focusNode: titleFocusNode,
            decoration: InputDecoration(
              hintText:
                  'Contoh: Cara Sukses Budidaya Lele dengan Sistem Biofloc untuk Pemula',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  (0.5 * 255).round(),
                ),
                fontStyle: FontStyle.italic,
              ),
              errorText: state.titleError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE53E3E),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.all(20),
            ),
            maxLength: 120,
            buildCounter:
                (_, {required currentLength, required isFocused, maxLength}) =>
                    null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => contentFocusNode.requestFocus(),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedContentField(
    ThemeData theme,
    CreatePostState state,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Detail Lengkap',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: state.content.length >= 50
                    ? const Color(0xFF00E676).withAlpha((0.1 * 255).round())
                    : theme.colorScheme.outline.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.content.length >= 50
                      ? const Color(0xFF00E676)
                      : theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Text(
                '${state.content.length} karakter',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: state.content.length >= 50
                      ? const Color(0xFF00B347)
                      : theme.colorScheme.onSurface.withAlpha(
                          (0.6 * 255).round(),
                        ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha((0.05 * 255).round()),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: state.content, // <-- TAMBAHKAN INI
            onChanged: (value) => ref
                .read(createPostControllerProvider.notifier)
                .onContentChanged(value),
            focusNode: contentFocusNode,
            decoration: InputDecoration(
              hintText:
                  '• Latar belakang (lokasi, ukuran kolam, dll.)\n• Metode yang digunakan\n• Tantangan yang dihadapi\n• Solusi yang diterapkan\n• Hasil dan pembelajaran\n• Tips untuk sesama peternak',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  (0.5 * 255).round(),
                ),
                height: 1.4,
              ),
              errorText: state.contentError,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE53E3E),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.all(20),
            ),
            maxLines: 12,
            minLines: 8,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withAlpha(
              (0.3 * 255).round(),
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tips: Ceritakan dengan detail dan spesifik. Semakin lengkap informasi yang Anda bagikan, semakin bermanfaat untuk komunitas.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTagsSection(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    CreatePostState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Tag Topik',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withAlpha(
                  (0.2 * 255).round(),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Opsional',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: state.tags.isNotEmpty
                    ? const Color(0xFF00E676).withAlpha((0.1 * 255).round())
                    : theme.colorScheme.outline.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.tags.isNotEmpty
                      ? const Color(0xFF00E676)
                      : theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Text(
                '${state.tags.length}/8 tag',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: state.tags.isNotEmpty
                      ? const Color(0xFF00B347)
                      : theme.colorScheme.onSurface.withAlpha(
                          (0.6 * 255).round(),
                        ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (state.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
                      theme.colorScheme.primary.withAlpha((0.05 * 255).round()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha(
                      (0.3 * 255).round(),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#$tag',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(createPostControllerProvider.notifier)
                            .removeTag(tag); // Gunakan controller yang di-pass
                      },
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (state.tags.isEmpty) const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha((0.05 * 255).round()),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            key: ValueKey(state.tags.join(',')),
            initialValue: state.tags.join(', '), // <-- UBAH INI
            onChanged: (value) => ref
                .read(createPostControllerProvider.notifier)
                .onTagsChanged(value),
            focusNode: tagsFocusNode,
            decoration: InputDecoration(
              hintText: 'lele, tips, dll (pisahkan dengan koma)',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  (0.5 * 255).round(),
                ),
              ),
              prefixIcon: Icon(
                Icons.tag,
                color: theme.colorScheme.primary.withAlpha((0.7 * 255).round()),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(
                    (0.5 * 255).round(),
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.all(16),
            ),
            maxLength: 200,
            buildCounter:
                (_, {required currentLength, required isFocused, maxLength}) =>
                    null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tag Populer',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withAlpha((0.8 * 255).round()),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestedTags
              .where((tag) => !state.tags.contains(tag))
              .take(8)
              .map((tag) {
                return GestureDetector(
                  onTap: () => onAddSuggestedTag(tag),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.outline.withAlpha(
                          (0.3 * 255).round(),
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withAlpha(
                            (0.05 * 255).round(),
                          ),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tag,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
              .toList(),
        ),
      ],
    );
  }
}
