// lib/features/presets/presentation/widgets/preset_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Impor file utama untuk mengakses AppColors dan model
import '../screens/preset_list_screen.dart';

class PresetCard extends ConsumerWidget {
  final Preset preset;
  final VoidCallback onTap;
  // [FIXED] Tambahkan parameter onDelete agar bisa dipanggil dari parent
  // final VoidCallback onDelete; // Kita akan gunakan menu popup saja

  const PresetCard({
    super.key,
    required this.preset,
    required this.onTap,
    // required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserCreated = preset.creator == PresetCreator.user;
    final parameterCount = preset.parameters.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        elevation: 2,
        shadowColor: Colors.black.withAlpha((0.04 * 255).round()),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPresetIcon(preset.commodity),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            preset.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            preset.commodity,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, right: 4.0),
                      child: _CreatorBadge(isUserCreated: isUserCreated),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -8),
                      child: _buildMenuButton(context, ref),
                    ),
                  ],
                ),
                if (preset.description != null &&
                    preset.description!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: Text(
                      preset.description!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                _buildParameterSummary(parameterCount),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetIcon(String commodity) {
    String emoji;
    Color backgroundColor;

    switch (commodity.toLowerCase()) {
      case 'lele':
        emoji = '🐟';
        backgroundColor = const Color(0xFFEFF6FF);
        break;
      case 'udang vaname':
        emoji = '🦐';
        backgroundColor = const Color(0xFFF0FDF4);
        break;
      case 'nila':
        emoji = '🐠';
        backgroundColor = const Color(0xFFFFF7ED);
        break;
      default:
        emoji = '🧪';
        backgroundColor = AppColors.primaryLight;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
    );
  }

  Widget _buildParameterSummary(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count parameter',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          onTap(); // Aksi edit memanggil onTap yang sudah ada
        }
        if (value == 'delete') {
          _showDeleteDialog(context, ref);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSpacing.sm),
              Text('Edit Preset'),
            ],
          ),
        ),
        if (preset.creator == PresetCreator.user)
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                SizedBox(width: AppSpacing.sm),
                Text('Hapus', style: TextStyle(color: AppColors.danger)),
              ],
            ),
          ),
      ],
      icon: const Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text(
          'Hapus Preset?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Preset "${preset.name}" akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // [FIXED] Memanggil notifier untuk menghapus preset
              ref.read(presetListProvider.notifier).deletePreset(preset.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Preset "${preset.name}" berhasil dihapus'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _CreatorBadge extends StatelessWidget {
  final bool isUserCreated;

  const _CreatorBadge({required this.isUserCreated});

  @override
  Widget build(BuildContext context) {
    const int backgroundAlpha = 26;
    const int borderAlpha = 77;

    final Color baseColor = isUserCreated
        ? AppColors.success
        : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: baseColor.withAlpha(backgroundAlpha),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: baseColor.withAlpha(borderAlpha), width: 1),
      ),
      child: Text(
        isUserCreated ? 'Saya' : 'Flocify',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: baseColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
