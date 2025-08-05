//lib/features/price/presentation/widgets/lapak/filter_row.dart
import 'package:flutter/material.dart';

class LapakFilterRow extends StatelessWidget {
  final String komoditas;
  final String lokasi;
  final VoidCallback onTapKomoditas;
  final VoidCallback onTapLokasi;

  const LapakFilterRow({
    super.key,
    required this.komoditas,
    required this.lokasi,
    required this.onTapKomoditas,
    required this.onTapLokasi,
  });

  @override
  Widget build(BuildContext context) {
    // --- ukuran yang bisa kamu tweak cepat ---
    const double boxHeight = 40; // sebelumnya ~48, kita kecilkan
    const double hPad = 12; // padding horizontal dalam kotak
    const double vPad = 8; // padding vertical dalam kotak
    const double fontSize = 14; // sebelumnya 16
    const double iconSize = 18; // sebelumnya 20
    const double radius = 10; // sebelumnya 12
    const double spacing = 8; // jarak antar kotak, sebelumnya 12
    const EdgeInsets outerPadding = EdgeInsets.fromLTRB(
      16,
      0,
      16,
      12,
    ); // sebelumnya bottom 16

    return Padding(
      padding: outerPadding,
      child: Row(
        children: [
          Expanded(
            child: _SmallSelectBox(
              label: komoditas,
              height: boxHeight,
              hPad: hPad,
              vPad: vPad,
              fontSize: fontSize,
              iconSize: iconSize,
              radius: radius,
              onTap: onTapKomoditas,
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: _SmallSelectBox(
              label: lokasi,
              height: boxHeight,
              hPad: hPad,
              vPad: vPad,
              fontSize: fontSize,
              iconSize: iconSize,
              radius: radius,
              onTap: onTapLokasi,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallSelectBox extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  final double height;
  final double hPad;
  final double vPad;
  final double fontSize;
  final double iconSize;
  final double radius;

  const _SmallSelectBox({
    required this.label,
    required this.onTap,
    required this.height,
    required this.hPad,
    required this.vPad,
    required this.fontSize,
    required this.iconSize,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: iconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
