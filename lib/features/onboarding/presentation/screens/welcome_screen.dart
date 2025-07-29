// lib/features/onboarding/presentation/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E88E5);
    // Dapatkan tinggi layar untuk memastikan layout bisa memenuhi layar
    final screenHeight = MediaQuery.of(context).size.height;
    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        // 1. Tambahkan SingleChildScrollView agar layar bisa di-scroll dan tahan terhadap keyboard
        child: SingleChildScrollView(
          child: ConstrainedBox(
            // 2. Pastikan Column memiliki tinggi minimal setinggi layar
            // Ini membuat konten tetap terlihat bagus di layar yang lebih besar
            constraints: BoxConstraints(minHeight: screenHeight - paddingTop),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              // 3. Hapus 'Expanded' dan atur alignment Column
              child: Column(
                // Gunakan spaceBetween untuk mendorong konten ke atas dan bawah
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Widget kosong untuk memberikan sedikit ruang di atas
                  const SizedBox(),

                  // --- KONTEN ATAS ---
                  // Kelompokkan konten atas dalam satu Column
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.water_drop,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Selamat Datang di Flocify',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Solusi cerdas untuk akuakultur modern.\nTingkatkan produktivitas dan keuntungan Anda.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  // --- KONTEN BAWAH ---
                  // Kelompokkan tombol dan teks di bawah
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ), // Beri padding bawah
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            ),
                            child: const Text('Masuk'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            ),
                            child: const Text('Daftar'),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Dengan melanjutkan, Anda menyetujui\nSyarat & Ketentuan dan Kebijakan Privasi',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
