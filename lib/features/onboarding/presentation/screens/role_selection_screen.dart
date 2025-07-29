// lib/features/onboarding/presentation/screens/role_selection_screen.dart

import 'package:flutter/material.dart';
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

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _navigateToNextScreen() {
    if (_selectedRole == null) return;

    // Ganti print dengan navigasi yang sebenarnya untuk semua peran
    if (_selectedRole == 'farmer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FarmerProfileScreen()),
      );
    } else if (_selectedRole == 'buyer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BuyerProfileScreen()),
      );
    } else {
      // 'supplier'
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SupplierProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E88E5);

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Gunakan Column sebagai layout utama
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian konten yang bisa di-scroll dibungkus dengan Expanded
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Pilih Peran Anda',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih peran yang sesuai dengan bisnis Anda.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
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
                      const SizedBox(height: 24), // Spasi di akhir list
                    ],
                  ),
                ),
              ),
              // Tombol diletakkan di luar Expanded, sehingga selalu di bawah
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _selectedRole != null
                      ? _navigateToNextScreen
                      : null,
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
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
    const Color primaryColor = Color(0xFF1E88E5);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? primaryColor.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
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
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primaryColor : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryColor, size: 24),
          ],
        ),
      ),
    );
  }
}
