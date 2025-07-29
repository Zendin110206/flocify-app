// lib/features/onboarding/presentation/screens/signup_screen.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import 'login_screen.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import 'package:proyek_flocify/features/users/presentation/providers/user_providers.dart';
import 'package:proyek_flocify/features/onboarding/presentation/screens/role_selection_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() =>
      setState(() => _obscurePassword = !_obscurePassword);
  void _toggleConfirmPasswordVisibility() =>
      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  void _setAgreeToTerms(bool? value) =>
      setState(() => _agreeToTerms = value ?? false);

  // Di dalam _SignupScreenState

  Future<void> _handleSignup() async {
    // Validasi form dan checkbox tetap sama
    if (!_agreeToTerms || !_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus menyetujui Syarat & Ketentuan'),
          ),
        );
      }
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _nameController.text.trim();
    // Tambahkan +62 jika belum ada
    final phoneNumber = _phoneController.text.trim().startsWith('0')
        ? '62${_phoneController.text.trim().substring(1)}'
        : _phoneController.text.trim();

    // Ambil notifier dari signupController. Kita akan menggunakannya untuk menampilkan status loading/error
    final signupNotifier = ref.read(signupControllerProvider.notifier);
    final userRepository = ref.read(userRepositoryProvider);

    try {
      // ---- LANGKAH 1: Buat Akun di Firebase Auth ----
      // Panggil use case untuk membuat user di Firebase Auth
      final userCredential = await signupNotifier.signUpAndReturnUser(
        email,
        password,
      );

      // Jika userCredential null, berarti terjadi error yang sudah ditangani oleh notifier
      if (userCredential == null) return;

      final uid = userCredential.uid;

      // ---- LANGKAH 2: Buat Dokumen Profil Awal di Firestore ----
      // Rakit objek UserProfile HANYA dengan data awal yang kita miliki.
      final initialProfile = UserProfile(
        uid: uid,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: UserRole.unknown, // Peran belum ditentukan
        isNewUser: true, // Flag untuk menandakan user baru
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // ---- LANGKAH 3: Simpan Profil Awal ke Firestore ----
      // Panggil userRepository secara langsung untuk menyimpan.
      // Ini adalah operasi kritis, jadi kita bungkus dengan try-catch juga
      // untuk menangani kemungkinan error koneksi ke Firestore.
      await userRepository.saveUserProfile(initialProfile);

      // ---- LANGKAH 4: Navigasi ke Layar Verifikasi ----
      // Jika semua berhasil, baru kita navigasi.
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // Kita ganti tujuan ke RoleSelectionScreen karena verifikasi belum fungsional
            builder: (context) => const RoleSelectionScreen(),
            // Atau jika verifikasi akan diimplementasikan:
            // builder: (context) => VerificationScreen(email: email),
          ),
        );
      }
    } catch (e) {
      // Tangani error yang mungkin dilempar dari saveUserProfile
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan data awal: ${e.toString()}")),
        );
      }
      // Pastikan controller signup juga direset ke state error jika terjadi kegagalan di sini
      signupNotifier.setError(e, StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupControllerProvider);
    final isLoading = signupState is AsyncLoading;
    const Color primaryColor = Color(0xFF1E88E5);

    ref.listen<AsyncValue<void>>(signupControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString().replaceFirst("Exception: ", ""),
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bergabunglah dengan ekosistem akuakultur cerdas.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration(
                    'Nama Lengkap',
                    Icons.person_outline,
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    'Email',
                    Icons.email_outlined,
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return 'Email tidak boleh kosong';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(v)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(
                    'Nomor Telepon',
                    Icons.phone_outlined,
                  ).copyWith(prefixText: '+62 '),
                  validator: (v) =>
                      v!.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration:
                      _buildInputDecoration(
                        'Kata Sandi',
                        Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                  validator: (v) {
                    if (v!.isEmpty) return 'Kata sandi tidak boleh kosong';
                    if (v.length < 6) return 'Kata sandi minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration:
                      _buildInputDecoration(
                        'Konfirmasi Kata Sandi',
                        Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                      ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Konfirmasi kata sandi tidak boleh kosong';
                    }
                    if (v != _passwordController.text) {
                      return 'Kata sandi tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildTermsCheckbox(primaryColor),
                const SizedBox(height: 32),
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
                    ),
                    onPressed: (_agreeToTerms && !isLoading)
                        ? _handleSignup
                        : null,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildLoginNavigation(context, primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData prefixIcon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildTermsCheckbox(Color primaryColor) {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: _setAgreeToTerms,
          activeColor: primaryColor,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              children: [
                const TextSpan(text: 'Saya setuju dengan '),
                TextSpan(
                  text: 'Syarat & Ketentuan',
                  style: TextStyle(
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => print('Buka Syarat & Ketentuan'),
                ),
                const TextSpan(text: ' dan '),
                TextSpan(
                  text: 'Kebijakan Privasi',
                  style: TextStyle(
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => print('Buka Kebijakan Privasi'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginNavigation(BuildContext context, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah punya akun? ',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          ),
          child: Text(
            'Masuk',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
