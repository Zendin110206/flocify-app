// Path: lib/core/widgets/smart_image.dart

import 'package:flutter/material.dart';

class SmartImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const SmartImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  // Getter sederhana untuk memeriksa apakah URL berasal dari internet
  bool get _isNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    // Widget ini akan menampilkan gambar yang sesuai dan membungkusnya dengan ClipRRect
    // untuk menangani border radius secara konsisten.
    return ClipRRect(borderRadius: borderRadius, child: _buildImage());
  }

  Widget _buildImage() {
    if (_isNetworkImage) {
      // Gunakan Image.network untuk URL dari internet
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        // Tampilkan loading indicator saat gambar sedang diunduh
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
        // Tampilkan icon error jika gagal memuat gambar
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else {
      // Gunakan Image.asset untuk path lokal
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }
  }

  // Widget privat untuk placeholder saat loading
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  // Widget privat untuk tampilan saat error
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      ),
    );
  }
}
