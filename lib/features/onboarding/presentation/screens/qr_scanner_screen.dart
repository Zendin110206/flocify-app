// lib/features/onboarding/presentation/screens/qr_scanner_screen.dart


import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'farmer_profile_screen.dart'; // Layar berikutnya yang akan kita buat

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  // --- PERUBAHAN 1: Buat Controller ---
  // Kita buat "remote control" untuk scanner kita.
  final MobileScannerController controller = MobileScannerController();

  // --- PERUBAHAN 2: Hapus 'isScanCompleted' ---
  // Kita tidak lagi memerlukan flag manual karena controller akan mengurusnya.

  @override
  void dispose() {
    // --- PERUBAHAN 3: Selalu dispose controller! ---
    // Ini sangat penting untuk mematikan kamera dan membebaskan memori
    // saat layar ini ditutup.
    controller.dispose();
    super.dispose();
  }
  
  void closeScreen() {
    // Navigator.pop akan secara otomatis memicu dispose(), jadi controller akan aman.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pindai QR Alat'),
        leading: IconButton(
          onPressed: closeScreen,
          icon: const Icon(Icons.close),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            // --- PERUBAHAN 4: Hubungkan Controller ke Widget ---
            controller: controller,
            onDetect: (capture) {
              // --- PERUBAHAN 5: Logika onDetect yang lebih aman ---
              // 1. Hentikan kamera agar tidak memindai terus-menerus
              controller.stop();
              
              final String code = capture.barcodes.first.rawValue ?? "Error";
              print('Device ID Terdeteksi: $code');
              
              // 2. Lakukan navigasi dengan aman
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const FarmerProfileScreen(),
                ),
              );
            },
          ),
          // Overlay UI (tidak ada perubahan di sini)
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Positioned(
            bottom: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.5*255).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Arahkan kamera pada QR code di alat Anda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}