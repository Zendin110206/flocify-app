// lib/features/onboarding/presentation/screens/verification_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/role_selection_screen.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _isChecking = false;
  bool _isResending = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E88E5);

    return Scaffold(
      // DIHILANGKAN: AppBar dihapus untuk mencegah navigasi yang tidak diinginkan.
      // Pengguna harus mengikuti alur verifikasi.
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80), // Tambah spasi karena AppBar hilang
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: primaryColor,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Verifikasi Email Anda',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kami telah mengirim link verifikasi ke alamat email:',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Setelah verifikasi, kembali ke aplikasi dan tekan tombol di bawah.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Tombol "Saya sudah verifikasi" dengan logika navigasi langsung
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: primaryColor.withOpacity(0.7),
                    ),
                    onPressed: _isChecking
                        ? null
                        : () async {
                            setState(() {
                              _isChecking = true;
                            });

                            User? user = FirebaseAuth.instance.currentUser;
                            await user?.reload();
                            user = FirebaseAuth
                                .instance
                                .currentUser; // Ambil ulang data terbaru

                            setState(() {
                              _isChecking = false;
                            });

                            // LOGIKA NAVIGASI EKSPLISIT
                            if (user?.emailVerified ?? false) {
                              if (mounted) {
                                // Navigasi langsung ke RoleSelectionScreen dan hapus layar ini dari tumpukan
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RoleSelectionScreen(),
                                  ),
                                );
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Email belum diverifikasi. Silakan periksa email Anda dan coba lagi.',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            }
                          },
                    child: _isChecking
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Saya Sudah Verifikasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol "Kirim Ulang"
                TextButton(
                  onPressed: _isResending
                      ? null
                      : () async {
                          setState(() {
                            _isResending = true;
                          });
                          try {
                            await FirebaseAuth.instance.currentUser
                                ?.sendEmailVerification();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Email verifikasi baru telah dikirim.',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Gagal mengirim ulang. Coba sesaat lagi.',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isResending = false;
                              });
                            }
                          }
                        },
                  child: _isResending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Kirim Ulang Email',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
