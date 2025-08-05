// lib/features/cultivation/presentation/widgets/cultivation_header.dart

import 'package:flutter/material.dart';

/// Widget utama yang menggabungkan gradien dan konten header.
/// Ini adalah satu-satunya widget yang perlu di-import oleh screen.
class CultivationHeader extends StatelessWidget {
  const CultivationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF638ECB), Color(0x808AAEE0), Color(0x008AAEE0)],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
      child: const SafeArea(bottom: false, child: _HeaderContent()),
    );
  }
}

/// Widget privat yang hanya berisi konten di dalam header.
class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    // Efek shadow untuk teks agar mudah terbaca di atas gradien
    const textShadow = [
      Shadow(
        color: Color.fromRGBO(0, 0, 0, 0.20),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Budidaya',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: textShadow,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pantau & kelola kokpit operasional Anda',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              shadows: textShadow,
            ),
          ),
        ],
      ),
    );
  }
}
