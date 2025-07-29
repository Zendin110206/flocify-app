// lib/features/asset_management/presentation/widgets/asset_tabs.dart

import 'package:flutter/material.dart';
import '../../domain/models/asset_models.dart';

class AssetTabs extends StatelessWidget {
  final TabController tabController;
  final List<DeviceModel> devices;
  final List<PondModel> ponds;

  const AssetTabs({
    super.key,
    required this.tabController,
    required this.devices,
    required this.ponds,
  });

  @override
  Widget build(BuildContext context) {
    // Container ini menciptakan efek kartu putih yang mengambang
    return Container(
      height: 50, // Tinggi standar untuk tab
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
      child: TabBar(
        controller: tabController,
        labelColor: const Color(0xFF395886),
        unselectedLabelColor: const Color(0xFF64748B),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF395886).withOpacity(0.15),
        ),

        // ✅ 2. Hilangkan gap default
        labelPadding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        tabs: [
          _buildTab('Perangkat', Icons.router_outlined, devices.length),
          _buildTab('Kolam', Icons.water_outlined, ponds.length),
        ],
      ),
    );
  }

  Widget _buildTab(String title, IconData icon, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text('$title ($count)'),
        ],
      ),
    );
  }
}
