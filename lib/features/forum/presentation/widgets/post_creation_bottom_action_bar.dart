// lib/features/forum/presentation/widgets/post_creation_bottom_action_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/create_post_controller.dart';

class PostCreationBottomActionBar extends ConsumerWidget {
  final Animation<double> submitAnimation;
  final VoidCallback onSubmit;

  const PostCreationBottomActionBar({
    super.key,
    required this.submitAnimation,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(createPostControllerProvider);
    final isFormValid = state.isFormValid;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withAlpha((0.1 * 255).round()),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha((0.1 * 255).round()),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isFormValid
                            ? const Color(0xFF00E676)
                            : theme.colorScheme.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isFormValid ? 'Siap dipublikasi' : 'Lengkapi form',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isFormValid
                            ? const Color(0xFF00B347)
                            : theme.colorScheme.onSurface.withAlpha(
                                (0.6 * 255).round(),
                              ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  state.formStatusMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(
                      (0.5 * 255).round(),
                    ),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          AnimatedBuilder(
            animation: submitAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (submitAnimation.value * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isFormValid && !state.isSubmitting
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withAlpha(
                                (0.4 * 255).round(),
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: isFormValid && !state.isSubmitting
                        ? onSubmit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormValid
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withAlpha(
                              (0.3 * 255).round(),
                            ),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: isFormValid ? 4 : 0,
                    ),
                    icon: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.publish, size: 20),
                    label: Text(
                      state.isSubmitting ? 'Memposting...' : 'Publikasikan',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
