// lib/features/onboarding/presentation/screens/supplier_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/core/screens/main_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/providers/profile_setup_controller.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import 'package:proyek_flocify/features/users/presentation/providers/user_providers.dart';
// ==========================================

class SupplierProfileScreen extends ConsumerStatefulWidget {
  const SupplierProfileScreen({super.key});

  @override
  ConsumerState<SupplierProfileScreen> createState() =>
      _SupplierProfileScreenState();
}

class _SupplierProfileScreenState extends ConsumerState<SupplierProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _locationController = TextEditingController();

  final List<String> _selectedProducts = [];

  final List<String> _productList = [
    'Pakan Ikan',
    'Bibit/Benih',
    'Obat-obatan',
    'Probiotik',
    'Aerator',
    'Pompa Air',
    'Jaring',
    'Peralatan Monitoring',
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onProductSelected(bool selected, String productName) {
    setState(() {
      if (selected) {
        _selectedProducts.add(productName);
      } else {
        _selectedProducts.remove(productName);
      }
    });
  }

  // === GANTI SELURUH METHOD _submitProfile LAMA DENGAN INI ===
  Future<void> _submitProfile() async {
    // 1. Validasi form dan pilihan produk.
    if (!_formKey.currentState!.validate() || _selectedProducts.isEmpty) {
      if (_selectedProducts.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih setidaknya satu produk yang disediakan'),
          ),
        );
      }
      return;
    }

    // 2. Baca state dari userProfileProvider untuk mendapatkan profil awal.
    final userProfileAsync = ref.read(userProfileProvider);

    // 3. Ekstrak data profil dari state AsyncValue.
    final currentProfile = userProfileAsync.asData?.value;

    // 4. Pengaman: Jika profil tidak bisa dimuat, hentikan proses.
    if (currentProfile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat data pengguna. Coba lagi.'),
          ),
        );
      }
      return;
    }

    // 5. Buat objek profil yang diperbarui menggunakan .copyWith().
    //    Ini akan mempertahankan uid, email, nama, no. telp, dan createdAt
    //    lalu memperbarui field sisanya.
    final updatedProfile = currentProfile.copyWith(
      // Data yang diperbarui
      role: UserRole.supplier, // Tetapkan peran pengguna
      isNewUser: false, // Tandai onboarding selesai
      updatedAt: DateTime.now(), // Perbarui waktu modifikasi
      // Data baru dari form di layar ini
      storeName: _businessNameController.text.trim(),
      storeLocation: _locationController.text.trim(),
      suppliedProducts: _selectedProducts,
    );

    // 6. Panggil controller untuk menyimpan profil yang SUDAH DIPERBARUI ke Firestore.
    final success = await ref
        .read(profileSetupControllerProvider.notifier)
        .saveProfile(updatedProfile);

    // 7. Jika penyimpanan berhasil, navigasi ke layar utama dan hapus riwayat navigasi.
    if (mounted && success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
  // =========================================================

  // === GANTI SELURUH METHOD build LAMA DENGAN INI ===
  @override
  Widget build(BuildContext context) {
    // Listener untuk menampilkan error dari controller saat proses simpan gagal
    ref.listen<AsyncValue<void>>(profileSetupControllerProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: ${next.error}')),
        );
      }
    });

    // 1. WATCH (awasi) userProfileProvider untuk membuat UI reaktif terhadap status data.
    final userProfileAsync = ref.watch(userProfileProvider);

    final profileSetupState = ref.watch(profileSetupControllerProvider);
    // isSaving adalah saat PROSES MENYIMPAN ke Firestore berjalan.
    final isSaving = profileSetupState is AsyncLoading;
    const Color primaryColor = Color(0xFF1E88E5);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profil Supplier',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // 2. Gunakan .when() untuk menangani semua kemungkinan state dari FutureProvider.
      body: userProfileAsync.when(
        // State saat data PROFIL AWAL berhasil didapatkan
        data: (userProfile) {
          // Pengaman jika profil null
          if (userProfile == null) {
            return const Center(child: Text('Gagal memuat profil pengguna.'));
          }

          // Tampilkan form jika data sudah siap
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                // Isi dari form tetap sama persis seperti kode Anda sebelumnya
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Lengkapi Profil Supplier',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      // Gunakan nama pengguna dari profil yang sudah dimuat
                      'Halo, ${userProfile.fullName}! Informasi ini akan membantu peternak menemukan produk Anda.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _businessNameController,
                      decoration: _buildInputDecoration(
                        'Nama Perusahaan/Toko',
                        Icons.store,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: _buildInputDecoration(
                        'Lokasi Usaha',
                        Icons.location_on,
                        hint: 'Kota, Provinsi',
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Lokasi tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Produk yang Disediakan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _productList.map((product) {
                        final isSelected = _selectedProducts.contains(product);
                        return FilterChip(
                          label: Text(product),
                          selected: isSelected,
                          onSelected: (selected) =>
                              _onProductSelected(selected, product),
                          // Perbaikan 'withOpacity' yang direkomendasikan sebelumnya
                          selectedColor: primaryColor.withAlpha(
                            (255 * 0.2).round(),
                          ),
                          checkmarkColor: primaryColor,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),

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
                        // Tombol dinonaktifkan jika PROSES MENYIMPAN sedang berjalan
                        onPressed: isSaving ? null : _submitProfile,
                        child: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Selesai',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
        // State saat FutureProvider sedang MEMUAT PROFIL AWAL
        loading: () => const Center(child: CircularProgressIndicator()),
        // State saat FutureProvider gagal (misal, tidak ada koneksi)
        error: (error, stackTrace) =>
            Center(child: Text('Terjadi kesalahan: $error')),
      ),
    );
  }
  // =========================================================

  InputDecoration _buildInputDecoration(
    String label,
    IconData prefixIcon, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
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
}
