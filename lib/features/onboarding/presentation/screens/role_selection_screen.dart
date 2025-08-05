// lib/features/onboarding/presentation/screens/role_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'farmer_profile_screen.dart';
import 'buyer_profile_screen.dart';
import 'supplier_profile_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  // REVISED: Using consistent color scheme
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _navigateToNextScreen() {
    if (_selectedRole == null) return;

    HapticFeedback.mediumImpact();
    Widget nextScreen;
    if (_selectedRole == 'farmer') {
      nextScreen = const FarmerProfileScreen();
    } else if (_selectedRole == 'buyer') {
      nextScreen = const BuyerProfileScreen();
    } else {
      // 'supplier'
      nextScreen = const SupplierProfileScreen();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PopScope adalah cara modern untuk mengontrol navigasi 'kembali'.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // REVISED: Header section made consistent
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _RoleCard(
                          title: 'Peternak/Budidaya',
                          description: 'Saya membudidayakan ikan atau udang',
                          icon: Icons.waves,
                          roleValue: 'farmer',
                          isSelected: _selectedRole == 'farmer',
                          onTap: () => _selectRole('farmer'),
                        ),
                        const SizedBox(height: 16),
                        _RoleCard(
                          title: 'Pembeli/Tengkulak',
                          description:
                              'Saya membeli hasil panen untuk dijual kembali',
                          icon: Icons.shopping_cart_outlined,
                          roleValue: 'buyer',
                          isSelected: _selectedRole == 'buyer',
                          onTap: () => _selectRole('buyer'),
                        ),
                        const SizedBox(height: 16),
                        _RoleCard(
                          title: 'Supplier/Distributor',
                          description:
                              'Saya menyediakan pakan, bibit, atau peralatan',
                          icon: Icons.inventory_2_outlined,
                          roleValue: 'supplier',
                          isSelected: _selectedRole == 'supplier',
                          onTap: () => _selectRole('supplier'),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedRole != null
                          ? primaryColor
                          : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _selectedRole != null ? 5 : 0,
                      shadowColor: primaryColor.withAlpha((0.4*255).round()),
                    ),
                    onPressed: _selectedRole != null
                        ? _navigateToNextScreen
                        : null,
                    child: const Text(
                      'Lanjutkan',
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
      ),
    );
  }

  // REVISED: Header widget yang sudah tidak memiliki tombol kembali
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Memberikan jarak dari atas layar untuk menggantikan posisi tombol.
        // Anda bisa sesuaikan nilainya jika terasa kurang pas.
        const SizedBox(height: 60),

        // Sisa dari header (Judul dan Subjudul) tetap sama.
        const Text(
          'Pilih Peran Anda',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pilih peran yang paling sesuai dengan bisnis Anda di ekosistem akuakultur.',
          style: TextStyle(
            fontSize: 17,
            color: textSecondary,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String roleValue;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.roleValue,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardPrimaryColor = Color(0xFF2563EB);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? cardPrimaryColor : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? cardPrimaryColor.withAlpha((0.05*255).round()) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? cardPrimaryColor.withAlpha((0.1*255).round())
                  : Colors.black.withAlpha((0.03*255).round()),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? cardPrimaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF475569),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? cardPrimaryColor
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.check_circle,
                  color: cardPrimaryColor,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
