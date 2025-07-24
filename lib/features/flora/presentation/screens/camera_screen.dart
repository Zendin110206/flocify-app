// Path: lib/features/flora/presentation/screens/camera_screen.dart
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyek_flocify/core/services/image_picker_service.dart';
import 'package:proyek_flocify/features/flora/presentation/providers/camera_screen_state.dart';
import 'package:proyek_flocify/features/flora/presentation/providers/flora_providers.dart';
import 'package:proyek_flocify/features/flora/presentation/screens/analysis_result_screen.dart';
import 'package:proyek_flocify/features/flora/presentation/widgets/camera_bottom_panel.dart';
import 'package:proyek_flocify/features/flora/presentation/widgets/camera_top_app_bar.dart';
import 'package:image_picker/image_picker.dart';

/// STATUS IZIN
enum PermissionStatusState { checking, granted, denied }

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // ─────────────────────────────────────────────────────────────────────────
  // CONTROLLER & KONSTANTA
  // ─────────────────────────────────────────────────────────────────────────
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  // Tinggi sheet adaptif
  static const double _sheetCollapsed = 0.22; // <-- TAMBAHKAN INI
  static const double _sheetShort = 0.52; // saat belum ada foto
  static const double _sheetTall = 0.60; // setelah ada foto

  PermissionStatusState _permissionStatus = PermissionStatusState.checking;

  // ─────────────────────────────────────────────────────────────────────────
  // INIT & DISPOSE
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initializeAnimations();
    _checkPermissionAndInitializeCamera();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraScreenControllerProvider.notifier).resetState();
    });
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _checkPermissionAndInitializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _permissionStatus = PermissionStatusState.granted);
      await _initializeCamera();
    } else {
      setState(() => _permissionStatus = PermissionStatusState.denied);
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      if (mounted)
        setState(() => _permissionStatus = PermissionStatusState.denied);
      return;
    }
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_permissionStatus != PermissionStatusState.granted) return;

    final cam = _cameraController;
    if (cam == null || !cam.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      cam.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    _draggableController.dispose(); // ← tambahkan

    _cameraController?.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DIALOG ERROR
  // ─────────────────────────────────────────────────────────────────────────
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terjadi Kesalahan'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // AKSI UTAMA
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    await _initializeControllerFuture;
    if (!_cameraController!.value.isTakingPicture) {
      try {
        final XFile imageFile = await _cameraController!.takePicture();
        HapticFeedback.heavyImpact();
        ref
            .read(cameraScreenControllerProvider.notifier)
            .captureAndAdvance(File(imageFile.path));
        // _draggableController.animateTo(
        //   _sheetTall,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeOut,
        // );
      } catch (e) {
        debugPrint('Error taking picture: $e');
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ref.read(imagePickerServiceProvider);
    final imageFile = await picker.pickImage(ImageSource.gallery);

    if (imageFile != null) {
      HapticFeedback.heavyImpact();
      ref
          .read(cameraScreenControllerProvider.notifier)
          .captureAndAdvance(imageFile);
      // _draggableController.animateTo(
      //   _sheetTall,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeOut,
      // );
    }
  }

  void _startAnalysis() {
    HapticFeedback.heavyImpact();
    ref.read(cameraScreenControllerProvider.notifier).startAnalysis();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // LISTEN success / error & tinggi sheet adaptif
    ref.listen<CameraScreenState>(cameraScreenControllerProvider, (prev, next) {
      if (!mounted) return;

      // sukses analisis
      if (next.status == CameraStatus.success && next.analysisResult != null) {
        final images = next.capturedImages.values.toList();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AnalysisResultScreen(
              result: next.analysisResult!,
              sourceImages: images,
            ),
          ),
        );
      }

      // error
      if (next.errorMessage != null && next.status == CameraStatus.error) {
        _showErrorDialog(next.errorMessage!);
      }

      // adaptasi tinggi sheet
      final prevEmpty = prev?.capturedImages.isEmpty ?? true;
      final nextEmpty = next.capturedImages.isEmpty;
      if (prevEmpty && !nextEmpty) {
        // Tunggu frame berikutnya agar maxChildSize sudah 0.60,
        // lalu naikkan sheet.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _draggableController.animateTo(
              _sheetTall, // 0.60
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
            );
          }
        });
      } else if (!prevEmpty && nextEmpty) {
        _draggableController.animateTo(
          _sheetShort,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    final state = ref.watch(cameraScreenControllerProvider);
    final bool hasCapturedImages = state.capturedImages.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: switch (_permissionStatus) {
        PermissionStatusState.checking => const Center(
          child: CircularProgressIndicator(),
        ),
        PermissionStatusState.denied => const _PermissionDeniedWidget(),
        PermissionStatusState.granted => Stack(
          children: [
            FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    _cameraController != null &&
                    _cameraController!.value.isInitialized) {
                  return Positioned.fill(
                    child: CameraPreview(_cameraController!),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            CameraTopAppBar(onClose: () => Navigator.of(context).pop()),
            DraggableScrollableSheet(
              controller: _draggableController,
              initialChildSize: _sheetShort,
              // Saat tidak ada gambar, kunci ukuran min & max di _sheetShort
              minChildSize: _sheetCollapsed,
              maxChildSize: hasCapturedImages ? _sheetTall : _sheetShort,
              builder: (context, scrollController) {
                return CameraBottomPanel(
                  scrollController: scrollController,
                  pulseAnimation: _pulseAnimation,
                  onCapture: _takePicture,
                  onGalleryTap: _pickFromGallery,
                  onStartAnalysis: _startAnalysis,
                );
              },
            ),
            if (state.status == CameraStatus.analyzing)
              const _AnalysisOverlay(),
          ],
        ),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// WIDGET BANTUAN
// ─────────────────────────────────────────────────────────────────────────
class _PermissionDeniedWidget extends StatelessWidget {
  const _PermissionDeniedWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.no_photography_rounded,
            color: Colors.white54,
            size: 80,
          ),
          const SizedBox(height: 24),
          const Text(
            'Izin Kamera Diperlukan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'FLORA memerlukan akses ke kamera Anda untuk dapat melakukan analisis. '
            'Mohon berikan izin melalui pengaturan aplikasi.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: openAppSettings,
            icon: const Icon(Icons.settings),
            label: const Text('Buka Pengaturan'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Kembali',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisOverlay extends StatelessWidget {
  const _AnalysisOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(217),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF6366F1)),
            SizedBox(height: 24),
            Text(
              'Menganalisis gambar...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
