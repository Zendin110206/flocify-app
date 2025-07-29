// lib/features/onboarding/presentation/screens/farmer_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/core/screens/main_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/providers/profile_setup_controller.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';

import 'package:proyek_flocify/features/users/presentation/providers/user_providers.dart'; // Untuk userRepositoryProvider

// Kita buat sebagai ConsumerStatefulWidget untuk state management lokal (dropdown, dll)
class FarmerProfileScreen extends ConsumerStatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  ConsumerState<FarmerProfileScreen> createState() =>
      _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends ConsumerState<FarmerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _pondCountController = TextEditingController();
  final _totalAreaController = TextEditingController();

  // State untuk dropdown
  String? _selectedSpecies;
  String? _selectedSystem;

  // Opsi untuk dropdown
  final List<String> _speciesList = [
    'Lele',
    'Nila',
    'Gurame',
    'Patin',
    'Udang Vaname',
    'Udang Windu',
    'Bandeng',
    'Mas',
    'Lainnya',
  ];
  final List<String> _systemList = [
    'Tradisional',
    'Semi-Intensif',
    'Intensif',
    'Super Intensif',
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    _pondCountController.dispose();
    _totalAreaController.dispose();
    super.dispose();
  }

  // Di dalam class _FarmerProfileScreenState

  // Di dalam class _FarmerProfileScreenState

  // === GANTI SELURUH METHOD _submitProfile LAMA DENGAN INI ===
  Future<void> _submitProfile() async {
    // 1. Validasi form, jika tidak valid, hentikan proses.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Baca state dari userProfileProvider.
    //    Provider ini secara otomatis mendapatkan profil dari pengguna yang sedang login.
    final userProfileAsync = ref.read(userProfileProvider);

    // 3. Ekstrak data profil dari state AsyncValue.
    final currentProfile = userProfileAsync.asData?.value;

    // 4. Pengaman: Jika profil tidak berhasil didapatkan (misal, koneksi error),
    //    tampilkan pesan error dan hentikan proses.
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

    // 5. Buat objek profil yang sudah diperbarui menggunakan .copyWith().
    //    Ini akan mengambil semua data lama (seperti uid, email, fullName, phoneNumber)
    //    dan menimpanya dengan data baru dari form di layar ini.
    final updatedProfile = currentProfile.copyWith(
      // Data yang diperbarui
      role: UserRole.farmer, // Tetapkan peran pengguna
      isNewUser: false, // Tandai onboarding selesai
      updatedAt: DateTime.now(), // Perbarui waktu modifikasi
      // Data baru dari form di layar ini
      farmName: _businessNameController.text.trim(),
      farmLocation: _locationController.text.trim(),
      farmingExperienceYears: int.tryParse(_experienceController.text.trim()),
      mainCommodity: _selectedSpecies,
      farmingSystem: _selectedSystem,
      pondCount: int.tryParse(_pondCountController.text.trim()),
      totalAreaSqm: double.tryParse(_totalAreaController.text.trim()),
    );

    // 6. Panggil controller untuk menyimpan profil yang SUDAH DIPERBARUI ke Firestore.
    final success = await ref
        .read(profileSetupControllerProvider.notifier)
        .saveProfile(updatedProfile);

    // 7. Jika penyimpanan berhasil, navigasi ke layar utama.
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
    // Listener untuk menampilkan error dari controller (tetap sama)
    ref.listen<AsyncValue<void>>(profileSetupControllerProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: ${next.error}')),
        );
      }
    });

    // === PERUBAHAN UTAMA DIMULAI DARI SINI ===

    // 1. WATCH (awasi) userProfileProvider, bukan cuma dibaca saat tombol ditekan.
    //    Ini akan membuat UI rebuild setiap kali status provider berubah (loading -> data -> error).
    final userProfileAsync = ref.watch(userProfileProvider);

    final profileSetupState = ref.watch(profileSetupControllerProvider);
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
          'Profil Peternak',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // 2. Gunakan .when() untuk menangani semua kemungkinan state dari FutureProvider.
      body: userProfileAsync.when(
        // State saat data berhasil didapatkan
        data: (userProfile) {
          // Jika data null (seharusnya tidak terjadi di alur ini, tapi sebagai pengaman),
          // tampilkan pesan error.
          if (userProfile == null) {
            return const Center(child: Text('Gagal memuat profil pengguna.'));
          }

          // Jika data berhasil dimuat, tampilkan form seperti biasa.
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                // Isi dari form tetap sama persis seperti sebelumnya.
                // (Column, TextFormField, Dropdown, Button, dll)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Lengkapi Profil Usaha',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      // Tampilkan nama pengguna yang sudah didapat dari Firestore
                      'Selamat datang, ${userProfile.fullName}! Bantu kami mengenal usaha Anda.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildSectionHeader('Informasi Usaha'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _businessNameController,
                      decoration: _buildInputDecoration(
                        'Nama Usaha',
                        Icons.business,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Nama usaha tidak boleh kosong' : null,
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        'Pengalaman Budidaya (Tahun)',
                        Icons.timeline,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Pengalaman tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 24),

                    _buildSectionHeader('Detail Budidaya'),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSpecies,
                      decoration: _buildInputDecoration(
                        'Jenis Komoditas Utama',
                        Icons.set_meal,
                      ),
                      items: _speciesList
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedSpecies = v),
                      validator: (v) =>
                          v == null ? 'Pilih jenis komoditas' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSystem,
                      decoration: _buildInputDecoration(
                        'Sistem Budidaya',
                        Icons.settings,
                      ),
                      items: _systemList
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedSystem = v),
                      validator: (v) =>
                          v == null ? 'Pilih sistem budidaya' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pondCountController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        'Jumlah Kolam',
                        Icons.pool,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Jumlah kolam tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _totalAreaController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        'Total Luas Area (m²)',
                        Icons.straighten,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Luas area tidak boleh kosong' : null,
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
                        // Gunakan isSaving dari profileSetupState
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
        // State saat FutureProvider sedang loading
        loading: () => const Center(child: CircularProgressIndicator()),
        // State saat FutureProvider gagal (misal, tidak ada koneksi internet)
        error: (error, stackTrace) =>
            Center(child: Text('Terjadi kesalahan: $error')),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

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
