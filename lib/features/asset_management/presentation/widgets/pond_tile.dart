// Path: lib/features/asset_management/presentation/widgets/pond_tile.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format angka
import '../../domain/models/asset_models.dart';

class PondTile extends StatelessWidget {
  final PondModel pond;
  const PondTile({super.key, required this.pond});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getPondStatusInfo(pond.status);
    final cardBorderColor = pond.status == PondStatus.healthy
        ? const Color(0xFFE2E8F0)
        : statusInfo.color.withOpacity(0.5);
    final formatter = NumberFormat.decimalPattern('id_ID');

    return InkWell(
      onTap: () {
        // TODO: Navigasi ke halaman detail kolam
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Buka detail untuk ${pond.name}')),
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
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.water,
                color: Color(0xFF3B82F6),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Konten di tengah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pond.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Baris status (Sehat/Perhatian/dll)
                  Row(
                    children: [
                      Icon(statusInfo.icon, size: 14, color: statusInfo.color),
                      const SizedBox(width: 6),
                      Text(
                        statusInfo.text,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusInfo.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Baris detail (Komoditas, Area, Jumlah Ekor)
                  Text(
                    '${pond.commodity} • ${pond.area} • ${formatter.format(pond.fishCount)} ekor',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Tampilkan nama perangkat jika terhubung
                  if (pond.connectedDevice != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.link,
                          size: 12,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Terhubung ke: ${pond.connectedDevice!}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
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

  // Helper function untuk mendapatkan warna, teks, dan ikon berdasarkan status
  ({Color color, String text, IconData icon}) _getPondStatusInfo(
    PondStatus status,
  ) {
    switch (status) {
      case PondStatus.healthy:
        return (
          color: const Color(0xFF10B981),
          text: 'Sehat',
          icon: Icons.check_circle_outline,
        );
      case PondStatus.warning:
        return (
          color: const Color(0xFFF59E0B),
          text: 'Perhatian',
          icon: Icons.warning_amber_rounded,
        );
      case PondStatus.disconnected:
        return (
          color: const Color(0xFF94A3B8),
          text: 'Tidak Terhubung',
          icon: Icons.cloud_off_outlined,
        );
    }
  }
}
