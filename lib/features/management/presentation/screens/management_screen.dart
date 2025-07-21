// lib/features/management/presentation/screens/management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pond_providers.dart';
import '../tabs/ringkasan_tab.dart';
import '../tabs/kolam_tab.dart';
import '../tabs/transaksi_tab.dart';
import '../tabs/analisis_tab.dart';

/// ===================================================================
/// MANAGEMENT SCREEN  –  Versi Hybrid (kembali ke look awal + polish)
/// ===================================================================
class ManagementScreen extends ConsumerWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: Color(0xFFF0F3FA),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _HeaderGradient(),
            // Konten utama overlap header (140 → lihat desain awal)
            Padding(
              padding: EdgeInsets.only(top: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_TabNavigation(), _TabContent()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===================================================================
/// HEADER GRADIENT
/// ===================================================================
class _HeaderGradient extends StatelessWidget {
  const _HeaderGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // kembali ke tinggi awal (lebih lega)
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF638ECB), Color(0x808AAEE0), Color(0x008AAEE0)],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
      child: const SafeArea(bottom: false, child: _HeaderContent()),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    const textShadow = [
      Shadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul + subjudul
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: textShadow,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kelola keuangan & produksi perikanan',
                  style: TextStyle(
                    color: Colors.white.withAlpha((255 * 0.9).round()),
                    fontSize: 14,
                    shadows: textShadow,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Tombol kecil kanan
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _HeaderIconButton(
                icon: Icons.add_circle_outline,
                semanticsLabel: 'Tambah Transaksi',
                onPressed: _notImplemented,
              ),
              SizedBox(width: 12),
              _HeaderIconButton(
                icon: Icons.download_outlined,
                semanticsLabel: 'Ekspor Data',
                onPressed: _notImplemented,
              ),
              SizedBox(width: 12),
              _HeaderIconButton(
                icon: Icons.analytics_outlined,
                semanticsLabel: 'Analisis Detail',
                onPressed: _notImplemented,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// sementara
void _notImplemented() {
  debugPrint('TODO: implement action.');
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String semanticsLabel;

  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    // visual tetap 32 (sama desain lama), tapi pakai InkWell utk ripple + aksesibilitas
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Ink(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((255 * 0.9).round()),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF292D32), size: 18),
          ),
        ),
      ),
    );
  }
}

/// ===================================================================
/// SEGMENTED TAB NAVIGATION  (balik look lama, polish minor)
/// ===================================================================
class _TabNavigation extends ConsumerWidget {
  const _TabNavigation();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ['Ringkasan', 'Kolam', 'Transaksi', 'Analisis'];
    final activeIndex = ref.watch(managementTabProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = activeIndex == index;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  ref.read(managementTabProvider.notifier).state = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF638ECB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// ===================================================================
/// TAB CONTENT SWITCHER
/// ===================================================================
class _TabContent extends ConsumerWidget {
  const _TabContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(managementTabProvider);

    switch (activeIndex) {
      case 0:
        return const RingkasanTab();
      case 1:
        return const KolamTab();
      case 2:
        return const TransaksiTab();
      case 3:
        return const AnalisisTab();
      default:
        return const SizedBox.shrink();
    }
  }
}
