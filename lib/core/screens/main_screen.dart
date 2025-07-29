// lib/core/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:proyek_flocify/core/widgets/custom_bottom_navbar.dart';
import 'package:proyek_flocify/features/management/presentation/screens/management_screen.dart';
// Jangan lupa import riverpod dan provider yang baru
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';
import 'package:proyek_flocify/features/home/presentation/screens/home_screen.dart';
import 'package:proyek_flocify/features/asset_management/presentation/screens/asset_management_screen.dart';

class HomePagePlaceholder extends ConsumerWidget {
  const HomePagePlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Panggil use case untuk sign out
              ref.read(signOutUseCaseProvider).call();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(child: Text('Halaman Home (Placeholder)')),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // Indeks 0 <-- Gunakan placeholder dulu
    const ManagementScreen(), // Indeks 1 <-- Halaman yang sudah kita refactor
    const AssetManagementScreen(), // Indeks 2
    const Center(child: Text('Halaman Analisis')), // Indeks 3
    const Center(child: Text('Halaman Parameter')), // Indeks 4
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
