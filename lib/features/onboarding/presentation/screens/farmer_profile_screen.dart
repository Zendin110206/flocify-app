// lib/features/onboarding/presentation/screens/farmer_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/core/screens/main_screen.dart';
import 'package:proyek_flocify/features/onboarding/presentation/providers/profile_setup_controller.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import 'package:proyek_flocify/features/users/presentation/providers/user_providers.dart';

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

  String? _selectedSpecies;
  String? _selectedSystem;

  // REVISED: Using consistent color scheme
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);

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

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HapticFeedback.mediumImpact();
    final userProfileAsync = ref.read(userProfileProvider);
    final currentProfile = userProfileAsync.asData?.value;

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

    final updatedProfile = currentProfile.copyWith(
      role: UserRole.farmer,
      isNewUser: false,
      updatedAt: DateTime.now(),
      farmName: _businessNameController.text.trim(),
      farmLocation: _locationController.text.trim(),
      farmingExperienceYears: int.tryParse(_experienceController.text.trim()),
      mainCommodity: _selectedSpecies,
      farmingSystem: _selectedSystem,
      pondCount: int.tryParse(_pondCountController.text.trim()),
      totalAreaSqm: double.tryParse(_totalAreaController.text.trim()),
    );

    final success = await ref
        .read(profileSetupControllerProvider.notifier)
        .saveProfile(updatedProfile);

    if (mounted && success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(profileSetupControllerProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: ${next.error}')),
        );
      }
    });

    final userProfileAsync = ref.watch(userProfileProvider);
    final profileSetupState = ref.watch(profileSetupControllerProvider);
    final isSaving = profileSetupState is AsyncLoading;

    return Scaffold(
      backgroundColor: backgroundColor,
      // REVISED: AppBar removed for custom header
      body: userProfileAsync.when(
        data: (userProfile) {
          if (userProfile == null) {
            return const Center(child: Text('Gagal memuat profil pengguna.'));
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // REVISED: Header made consistent
                    _buildHeader(userProfile.fullName),
                    const SizedBox(height: 32),

                    _buildSectionHeader('Informasi Usaha'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _businessNameController,
                      decoration: _buildInputDecoration(
                        'Nama Usaha',
                        Icons.business_center_outlined,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Nama usaha tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: _buildInputDecoration(
                        'Lokasi Usaha',
                        Icons.location_on_outlined,
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
                        Icons.timeline_outlined,
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
                        Icons.set_meal_outlined,
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
                        Icons.settings_outlined,
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
                        Icons.pool_outlined,
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
                        Icons.square_foot_outlined,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Luas area tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          shadowColor: primaryColor.withOpacity(0.4),
                        ),
                        onPressed: isSaving ? null : _submitProfile,
                        child: isSaving
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Selesai & Simpan Profil',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Terjadi kesalahan: $error')),
      ),
    );
  }

  // REVISED: Header widget to match other screens
  Widget _buildHeader(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF64748B),
                  size: 18,
                ),
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(milliseconds: 600));

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          'Profil Peternak',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selamat datang, $userName! Lengkapi profil untuk melanjutkan.',
          style: const TextStyle(
            fontSize: 17,
            color: textSecondary,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textPrimary,
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
      prefixIcon: Icon(prefixIcon, color: textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(color: textSecondary),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
