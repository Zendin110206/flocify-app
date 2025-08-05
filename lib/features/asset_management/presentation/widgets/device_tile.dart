// Path: lib/features/asset_management/presentation/widgets/device_tile.dart

import 'package:flutter/material.dart';
import '../../domain/models/asset_models.dart';

class DeviceTile extends StatelessWidget {
  final DeviceModel device;

  const DeviceTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final isOnline = device.status == DeviceStatus.online;
    final statusColor = isOnline
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);
    final cardBorderColor = isOnline
        ? const Color(0xFFE2E8F0)
        : statusColor.withAlpha((0.5*255).round());
    final iconBgColor = isOnline
        ? const Color(0xFF638ECB).withAlpha((0.1*255).round())
        : statusColor.withAlpha((0.1*255).round());
    final iconColor = isOnline ? const Color(0xFF638ECB) : statusColor;

    return InkWell(
      onTap: () {
        // TODO: Navigasi ke halaman detail perangkat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Buka detail untuk ${device.name}')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cardBorderColor),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon di sebelah kiri
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.router, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            // Konten di tengah (Nama, Status, Sensor)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Baris status (Online/Offline)
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        device.lastSeen,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Daftar sensor
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: device.sensors
                        .map((sensor) => _buildSensorChip(sensor))
                        .toList(),
                  ),
                ],
              ),
            ),
            // Ikon panah di sebelah kanan
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat chip sensor
  Widget _buildSensorChip(String sensor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        sensor,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF475569),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
