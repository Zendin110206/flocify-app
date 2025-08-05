import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import 'package:proyek_flocify/features/users/presentation/providers/user_providers.dart';
import '../../domain/models/asset_models.dart';
import 'asset_tabs.dart';

class AssetHeader extends ConsumerWidget {
  final List<DeviceModel> devices;
  final List<PondModel> ponds;
  final TabController tabController; // ⬅️  tambahkan controller

  const AssetHeader({
    super.key,
    required this.devices,
    required this.ponds,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileStreamProvider);
    final offlineDevices = devices
        .where((d) => d.status == DeviceStatus.offline)
        .length;
    final problemPonds = ponds
        .where((p) => p.status != PondStatus.healthy)
        .length;

    const double gradientHeight = 220.0;

    return Stack(
      children: [
        // ---------------------------------------------------------------
        //  Lapisan 1: background gradient (tinggi tetap)
        // ---------------------------------------------------------------
        const Positioned.fill(
          child: ColoredBox(
            color: Color(0xFFF8FAFC), // sama seperti background Scaffold
          ),
        ),

        Container(
          height: gradientHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF638ECB), Color(0x808AAEE0), Color(0x00F0F3FA)],
              stops: [0.0, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),

        // ---------------------------------------------------------------
        //  Lapisan 2: konten (tinggi otomatis)
        // ---------------------------------------------------------------
        SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAppBar(context),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildGreeting(userProfileAsync),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildQuickStatusOverview(offlineDevices, problemPonds),
              ),

              // ---------------------------------------------------------
              //  TabBar langsung jadi bagian dari header (tidak overlapping)
              // ---------------------------------------------------------
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AssetTabs(
                  tabController: tabController,
                  devices: devices,
                  ponds: ponds,
                ),
              ),

              // Spacer kecil supaya konten berikutnya tidak “nempel”
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  //  Sisa helper widgets (tidak berubah kecuali kalau terlihat tanda NEW)
  // ---------------------------------------------------------------------
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
      child: Row(
        children: [
          const Text(
            'Kelola Aset',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune, color: Colors.white),
            tooltip: 'Filter & Urutkan',
            onSelected: (value) {
              /* TODO */
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'sort_status',
                child: Text('Urutkan: Status'),
              ),
              PopupMenuItem(value: 'sort_name', child: Text('Urutkan: Nama')),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'filter_all',
                child: Text('Tampilkan: Semua'),
              ),
              PopupMenuItem(
                value: 'filter_online',
                child: Text('Tampilkan: Online/Terhubung'),
              ),
              PopupMenuItem(
                value: 'filter_offline',
                child: Text('Tampilkan: Offline/Bermasalah'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(AsyncValue<UserProfile?> userProfileAsync) {
    return userProfileAsync.when(
      data: (user) {
        final initials = (user?.fullName.isNotEmpty ?? false)
            ? user!.fullName.substring(0, 1).toUpperCase()
            : 'F';
        return Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white70,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Color(0xFF395886),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${user?.fullName ?? 'Pengguna'}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Pantau kolam dan perangkat Anda',
                    style: TextStyle(
                      color: Colors.white.withAlpha((0.9*255).round()),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: _buildGreetingPlaceholder,
      error: (_, __) => _buildGreetingPlaceholder(),
    );
  }

  Widget _buildGreetingPlaceholder() {
    return Row(
      children: [
        const CircleAvatar(radius: 24, backgroundColor: Colors.white30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                height: 18,
                width: 120,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              SizedBox(height: 6),
              SizedBox(
                height: 14,
                width: 180,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatusOverview(int offlineDevices, int problemPonds) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatusCard(
              'Perangkat Offline',
              '$offlineDevices/${devices.length}',
              Icons.router_outlined,
              offlineDevices > 0
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF10B981),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFE2E8F0),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: _buildStatusCard(
              'Kolam Bermasalah',
              '$problemPonds/${ponds.length}',
              Icons.water_outlined,
              problemPonds > 0
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
