// lib/features/forum/presentation/widgets/post_creation_progress_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/create_post_controller.dart';

class PostCreationProgressHeader extends ConsumerWidget {
  const PostCreationProgressHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Widget ini sekarang mengambil state-nya sendiri, membuatnya independen.
    final state = ref.watch(createPostControllerProvider);
    final progress = state.formCompletionProgress;

    return Container(
      // Margin top disesuaikan untuk berada di bawah AppBar
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha((0.9*255).round()),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha((0.1*255).round()),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progres Penulisan',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha((0.7*255).round()),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toInt()}% Selesai',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha((0.5*255).round()),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha((0.3*255).round()),
                  ),
                ),
                child: Text(
                  '${state.title.length + state.content.length} karakter',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.outline.withAlpha((0.2*255).round()),
              valueColor: AlwaysStoppedAnimation(
                progress >= 1.0
                    ? const Color(0xFF00E676)
                    : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
