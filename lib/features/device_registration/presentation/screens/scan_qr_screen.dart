// Path: lib/features/device_registration/presentation/screens/scan_qr_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/device_config_bottom_sheet.dart'; // Akan kita buat
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends ConsumerStatefulWidget {
  const ScanQrScreen({super.key});

  @override
  ConsumerState<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends ConsumerState<ScanQrScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _scanAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  final MobileScannerController _scannerController = MobileScannerController();

  // UI State
  bool _isScanning = true;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    // Setup animation controllers
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _scanAnimationController.repeat(reverse: true);
    _pulseAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _pulseAnimationController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    _scannerController.toggleTorch(); // Gunakan method dari controller
    setState(() => _isFlashOn = !_isFlashOn);
    HapticFeedback.lightImpact();
  }

  // Method untuk mensimulasikan QR terdeteksi
  void _onQRDetected(String qrCode) {
    if (!_isScanning) return; // Mencegah pemanggilan berulang

    HapticFeedback.mediumImpact();
    setState(() => _isScanning = false);

    // Beri jeda agar animasi sukses terlihat
    Future.delayed(const Duration(milliseconds: 500), () {
      // TODO: Kirim qrCode ke provider/controller
      _showDeviceConfigDialog();
    });
  }

  void _showDeviceConfigDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DeviceConfigBottomSheet(), // Akan kita buat
    );
  }

  @override
  Widget build(BuildContext context) {
    final cameraPreview = MobileScanner(
      controller: _scannerController, // Hubungkan controller
      // onDetect dipanggil setiap kali QR code terdeteksi
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          final String? qrCodeValue = barcodes.first.rawValue;
          if (qrCodeValue != null) {
            // Panggil method kita dengan data asli dari QR code
            _onQRDetected(qrCodeValue);
          }
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Latar Belakang (Kamera)
          Positioned.fill(child: cameraPreview),

          // 2. Overlays & UI
          // Kita akan pecah UI menjadi widget-widget terpisah
          _buildTopBar(),
          _buildScannerFrame(),
          _buildBottomControls(),
        ],
      ),
    );
  }

  // Helper Widget untuk Top Bar (Tombol Kembali & Flash)
  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Kembali
            _buildControlButton(
              onPressed: () => Navigator.pop(context),
              icon: Icons.close,
            ),
            // Tombol Flash
            _buildControlButton(
              onPressed: _toggleFlash,
              icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
              iconColor: _isFlashOn ? Colors.yellow.shade700 : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Frame, Judul, dan Animasi
  Widget _buildScannerFrame() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          const Text(
            'Scan Perangkat Flocify',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Arahkan kamera ke QR code pada Flocify Board',
            style: TextStyle(
              color: Colors.white.withAlpha((0.8*255).round()),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Frame dan animasinya
          SizedBox(
            width: 280,
            height: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Bingkai utama
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withAlpha((0.3*255).round()),
                      width: 2,
                    ),
                  ),
                ),
                // Sudut-sudut
                _buildCornerBrackets(),
                // Animasi garis scan
                if (_isScanning) _buildScanningLine(),
                // Animasi sukses
                if (!_isScanning) _buildSuccessIndicator(),
              ],
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // Helper Widget untuk Kontrol Bawah
  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha((0.4*255).round()),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withAlpha((0.1*255).round())),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isScanning
                            ? const Color(0xFF059669)
                            : const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isScanning
                            ? 'Mencari QR code...'
                            : 'QR code terdeteksi!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol simulasi
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET-WIDGET UNTUK ANIMASI (TIDAK PERLU DIUBAH) ---
  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color iconColor = Colors.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.3*255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha((0.1*255).round())),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _buildCornerBrackets() {
    return Stack(
      children: List.generate(4, (index) {
        final alignments = [
          Alignment.topLeft,
          Alignment.topRight,
          Alignment.bottomLeft,
          Alignment.bottomRight,
        ];
        return Align(
          alignment: alignments[index],
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: index < 2
                      ? const Color(0xFF2563EB)
                      : Colors.transparent,
                  width: 4,
                ),
                bottom: BorderSide(
                  color: index >= 2
                      ? const Color(0xFF2563EB)
                      : Colors.transparent,
                  width: 4,
                ),
                left: BorderSide(
                  color: index % 2 == 0
                      ? const Color(0xFF2563EB)
                      : Colors.transparent,
                  width: 4,
                ),
                right: BorderSide(
                  color: index % 2 != 0
                      ? const Color(0xFF2563EB)
                      : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScanningLine() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: 20 + (_scanAnimation.value * 240),
          child: Container(
            width: 240,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF2563EB).withAlpha((0.8*255).round()),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB),
                  blurRadius: 10.0,
                  spreadRadius: 0.1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Opacity(
            opacity: 1.5 - _pulseAnimation.value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
          ),
        );
      },
    );
  }
}
