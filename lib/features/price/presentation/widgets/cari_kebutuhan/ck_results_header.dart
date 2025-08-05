//lib/features/price/presentation/widgets/cari_kebutuhan/ck_results_header.dart
import 'package:flutter/material.dart';
import 'ck_colors.dart';

class CKResultsHeader extends StatelessWidget {
  final int count;
  const CKResultsHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CKColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count permintaan ditemukan',
            style: const TextStyle(
              color: CKColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.circle, size: 8, color: CKColors.success),
                SizedBox(width: 4),
                Text(
                  'Live',
                  style: TextStyle(
                    color: CKColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
