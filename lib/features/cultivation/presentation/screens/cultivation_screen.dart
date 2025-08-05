// lib/features/cultivation/presentation/screens/cultivation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cultivation_header.dart';
import '../widgets/pond_selector.dart';
import '../widgets/system_status_cards.dart'; // Import widget baru

class CultivationScreen extends ConsumerWidget {
  const CultivationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F3FA),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CultivationHeader(),
            Padding(
              padding: EdgeInsets.only(top: 132),
              child: _CultivationContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CultivationContent extends StatelessWidget {
  const _CultivationContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // Pond Selector
        PondSelector(),

        SizedBox(height: 24),

        // System Status Cards - Widget baru yang kita buat
        SystemStatusCards(),

        // Ruang untuk konten berikutnya
        SizedBox(height: 24),

        Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Parameter monitoring dan fitur lainnya akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
