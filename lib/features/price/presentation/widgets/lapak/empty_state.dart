// lib/widgets/lapak/empty_state.dart
import 'package:flutter/material.dart';

class LapakEmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onUbahFilter;

  const LapakEmptyState({
    super.key,
    required this.message,
    required this.onUbahFilter,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.grey[600];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 72, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              'Data tidak ditemukan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onUbahFilter,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Text('Ubah Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
