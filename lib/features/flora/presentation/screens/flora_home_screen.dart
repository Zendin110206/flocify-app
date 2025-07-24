// Path: lib/features/flora/presentation/screens/flora_home_screen.dart

import 'package:flutter/material.dart';
import 'package:proyek_flocify/features/flora/presentation/screens/history_screen.dart';
import '../screens/camera_screen.dart';
// Tambahkan import ini di atas
import 'chat_screen.dart';


class FloraHomeScreen extends StatelessWidget {
  const FloraHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita tidak perlu backgroundColor di sini karena Stack akan mengurusnya
      body: Stack(
        children: [
          // LAPISAN 1: WARNA SOLID (Sama seperti background HomeScreen)
          // Ini akan menjadi warna dasar untuk bagian bawah layar.
          Container(color: const Color(0xFFF0F3FA)),

          // LAPISAN 2: GRADASI WARNA DI BAGIAN ATAS
          // Container ini tingginya tetap, sehingga gradasi tidak meregang.
          Container(
            height: 240, // Tinggi yang sama dengan HomeHeader
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF638ECB),
                  Color(0x808AAEE0),
                  Color(0x008AAEE0),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // LAPISAN 3: KONTEN UTAMA HALAMAN
          // Semua konten asli kita letakkan di atas lapisan background.
          SafeArea(
            child: Column(
              children: [
                // --- AppBar Kustom ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Kembali
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      // // Judul
                      // const Text(
                      //   'FLORA',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.w600,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      // Tombol Riwayat
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.history, color: Colors.white),
                          tooltip: 'Riwayat Deteksi',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // --- Konten Utama (dari prototype) ---
                const _MainContent(),
                const Spacer(),
                // --- Tombol Aksi ---
                const _ActionButtons(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget _MainContent dan _ActionButtons tidak perlu diubah (tetap sama)
class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.camera_enhance_rounded, color: Color(0xFF395886), size: 120),
        SizedBox(height: 24),
        Text(
          'Flocify Recognition AI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            'Membantu mendeteksi penyakit pada hewan budidaya Anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7F8C8D),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: const Color(0xFF395886),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Mulai Deteksi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              side: const BorderSide(color: Color(0xFF395886), width: 1.5),
              foregroundColor: const Color(0xFF395886),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Tanya FLORA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
