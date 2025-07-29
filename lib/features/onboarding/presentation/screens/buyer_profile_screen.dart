// lib/features/onboarding/presentation/screens/buyer_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/core/screens/main_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/providers/profile_setup_controller.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import 'package:proyek_flocify/features/users/presentation/providers/user_providers.dart';

class BuyerProfileScreen extends ConsumerStatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  ConsumerState<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends ConsumerState<BuyerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();

  String? _selectedBuyerType;
  final List<String> _selectedSpecies = [];

  final List<String> _buyerTypes = [
    'Tengkulak/Pengumpul',
    'Supplier Restoran',
    'Distributor Pasar',
    'Eksportir',
    'Industri Pengolahan',
  ];
  final List<String> _speciesList = [
    'Lele',
    'Nila',
    'Gurame',
    'Patin',
    'Udang Vaname',
    'Udang Windu',
    'Bandeng',
    'Mas',
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _onSpeciesSelected(bool selected, String speciesName) {
    setState(() {
      if (selected) {
        _selectedSpecies.add(speciesName);
      } else {
        _selectedSpecies.remove(speciesName);
      }
    });
  }

  Future<void> _submitProfile() async {
    // 1. Validasi form dan pilihan komoditas.
    if (!_formKey.currentState!.validate() || _selectedSpecies.isEmpty) {
      if (_selectedSpecies.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih setidaknya satu komoditas yang diminati'),
          ),
        );
      }
      return;
    }

    // 2. Baca state dari userProfileProvider.
    final userProfileAsync = ref.read(userProfileProvider);

    // 3. Ekstrak data profil.
    final currentProfile = userProfileAsync.asData?.value;

    // 4. Pengaman jika data tidak ada.
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
    //    Perhatikan field yang diisi spesifik untuk Buyer.
    final updatedProfile = currentProfile.copyWith(
      // Data yang diperbarui
      role: UserRole.buyer, // Tetapkan peran pengguna
      isNewUser: false, // Tandai onboarding selesai
      updatedAt: DateTime.now(), // Perbarui waktu modifikasi
      // Data baru dari form di layar ini
      buyerBusinessName: _businessNameController.text.trim(),
      buyerBusinessType: _selectedBuyerType,
      buyerBusinessLocation: _locationController.text.trim(),
      purchaseCapacityKgPerMonth: int.tryParse(_capacityController.text.trim()),
      interestedCommodities: _selectedSpecies,
    );

    // 6. Panggil controller untuk menyimpan profil yang SUDAH DIPERBARUI.
    final success = await ref
        .read(profileSetupControllerProvider.notifier)
        .saveProfile(updatedProfile);

    // 7. Jika berhasil, navigasi ke layar utama.
    if (mounted && success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

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

    // 1. WATCH (awasi) userProfileProvider untuk membuat UI reaktif.
    final userProfileAsync = ref.watch(userProfileProvider);

    final profileSetupState = ref.watch(profileSetupControllerProvider);
    // Nama variabel diubah agar lebih jelas, isSaving adalah saat PROSES MENYIMPAN berjalan.
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
          'Profil Pembeli',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // 2. Gunakan .when() untuk menangani semua state dari FutureProvider.
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
                      'Lengkapi Profil Bisnis',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      // Gunakan nama pengguna yang sudah didapat dari Firestore
                      'Halo, ${userProfile.fullName}! Informasi ini akan membantu peternak menemukan Anda.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _businessNameController,
                      decoration: _buildInputDecoration(
                        'Nama Perusahaan/Usaha',
                        Icons.business,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Nama usaha tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedBuyerType,
                      decoration: _buildInputDecoration(
                        'Jenis Bisnis',
                        Icons.category,
                      ),
                      items: _buyerTypes
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBuyerType = v),
                      validator: (v) => v == null ? 'Pilih jenis bisnis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: _buildInputDecoration(
                        'Lokasi Bisnis',
                        Icons.location_on,
                        hint: 'Kota, Provinsi',
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Lokasi tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        'Kapasitas Pembelian (kg/bulan)',
                        Icons.scale,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Kapasitas tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Komoditas yang Diminati',
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
                      children: _speciesList.map((species) {
                        final isSelected = _selectedSpecies.contains(species);
                        return FilterChip(
                          label: Text(species),
                          selected: isSelected,
                          onSelected: (selected) =>
                              _onSpeciesSelected(selected, species),
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
        // State saat FutureProvider gagal
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
