// lib/features/home/presentation/widgets/home_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/auth/presentation/providers/auth_providers.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF638ECB), Color(0x808AAEE0), Color(0x008AAEE0)],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/logo_flocify_putih.png', height: 35),
              Row(
                children: [
                  _buildHeaderIcon(Icons.notifications_outlined, () {}),
                  const SizedBox(width: 12),
                  _buildHeaderIcon(Icons.logout, () {
                    ref.read(signOutUseCaseProvider).call();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.9*255).round()),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF292D32), size: 20),
      ),
    );
  }
}
