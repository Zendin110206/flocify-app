//lib/features/price/presentation/widgets/cari_kebutuhan/ck_selection_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'ck_colors.dart';

class CKSelectionBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<String> items,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: CKColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.6;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: CKColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: CKColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final selected = item == currentValue;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item),
                        trailing: selected
                            ? const Icon(Icons.check, color: CKColors.success)
                            : null,
                        onTap: () {
                          onSelected(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
