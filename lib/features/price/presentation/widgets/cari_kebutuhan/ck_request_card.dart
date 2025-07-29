// lib/widgets/cari_kebutuhan/ck_request_card.dart
import 'package:flutter/material.dart';
import 'ck_colors.dart';

enum CKBuyerType { eksportir, restoran, tengkulak, supplier }

extension _BuyerExt on CKBuyerType {
  String get name {
    switch (this) {
      case CKBuyerType.eksportir:
        return 'Eksportir';
      case CKBuyerType.restoran:
        return 'Restoran';
      case CKBuyerType.tengkulak:
        return 'Tengkulak';
      case CKBuyerType.supplier:
        return 'Supplier';
    }
  }

  Color get color {
    switch (this) {
      case CKBuyerType.eksportir:
        return CKColors.accentBlue;
      case CKBuyerType.restoran:
        return Color(0xFF7C3AED);
      case CKBuyerType.tengkulak:
        return Color(0xFFEA580C);
      case CKBuyerType.supplier:
        return CKColors.success;
    }
  }
}

class CKRequestData {
  final String title;
  final String quantity;
  final String size;
  final String location;
  final double pricePerKg;
  final bool urgent;
  final bool pickup;
  final String buyerName;
  final CKBuyerType buyerType;
  final String timeLeftLabel;

  const CKRequestData({
    required this.title,
    required this.quantity,
    required this.size,
    required this.location,
    required this.pricePerKg,
    required this.urgent,
    required this.pickup,
    required this.buyerName,
    required this.buyerType,
    required this.timeLeftLabel,
  });

  String get formattedPrice {
    final s = pricePerKg.toStringAsFixed(0);
    final rev = s.split('').reversed.join();
    final withDot = rev.replaceAllMapped(RegExp(r'.{1,3}'), (m) => '${m[0]}.');
    final result = withDot.split('').reversed.join();
    return 'Rp ${result.startsWith('.') ? result.substring(1) : result}/kg';
  }
}

class CKRequestCard extends StatelessWidget {
  final CKRequestData data;
  final VoidCallback onContact;
  final VoidCallback onBookmark;

  const CKRequestCard({
    super.key,
    required this.data,
    required this.onContact,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CKColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CKColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(), _details(), _actions()],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (data.urgent) _urgentBadge(),
                    if (data.urgent) const SizedBox(width: 8),
                    _buyerTypeBadge(),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CKColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.buyerName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CKColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.formattedPrice,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CKColors.success,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.timeLeftLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: data.urgent ? CKColors.urgent : CKColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _details() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              _detailItem(Icons.scale_outlined, 'Kuantitas', data.quantity),
              const SizedBox(width: 24),
              _detailItem(Icons.straighten_outlined, 'Ukuran', data.size),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: CKColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        data.location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: CKColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (data.pickup) _pickupBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onContact,
              icon: const Icon(Icons.phone, size: 16),
              label: const Text(
                'Hubungi Pembeli',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                backgroundColor: CKColors.textPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              border: Border.all(color: CKColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: onBookmark,
              icon: const Icon(Icons.bookmark_border, size: 20),
              color: CKColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _urgentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'URGENT',
        style: TextStyle(
          color: CKColors.urgent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buyerTypeBadge() {
    final c = data.buyerType.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        data.buyerType.name,
        style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _pickupBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.local_shipping_outlined,
            size: 12,
            color: CKColors.success,
          ),
          SizedBox(width: 4),
          Text(
            'Jemput di lokasi',
            style: TextStyle(
              color: CKColors.success,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: CKColors.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: CKColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CKColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
