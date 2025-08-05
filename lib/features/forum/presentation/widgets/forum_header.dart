// lib/features/forum/presentation/widgets/forum_header.dart

import 'package:flutter/material.dart';

/// The static header widget for the Forum screen.
class ForumHeader extends StatelessWidget {
  const ForumHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 24,
      ), // Padding bawah dipindah ke sini
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF638ECB), Color(0x808AAEE0), Color(0x00F0F3FA)],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        // DIHAPUS: Padding utama yang menyebabkan masalah dihilangkan.
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              // BAGIAN 1: AppBar - Tanpa padding horizontal agar menempel di tepi.
              child: Row(
                children: [
                  // DIKEMBALIKAN: IconButton normal dengan padding default untuk UX yang baik.
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Forum',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // BAGIAN 2: Konten - Diberi padding sendiri agar menjorok ke dalam.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white70,
                        child: Icon(Icons.person, color: Color(0xFF395886)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, Pak Asep!', // TODO: Replace with actual user name
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withAlpha(
                                      (0.25 * 255).round(),
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Ayo, sharing bersama pembudidaya lainnya!',
                              style: TextStyle(
                                color: Colors.white.withAlpha(
                                  (0.85 * 255).round(),
                                ),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.1 * 255).round()),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari topik di forum...',
                        icon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
