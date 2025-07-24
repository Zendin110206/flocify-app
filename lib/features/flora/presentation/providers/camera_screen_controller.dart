// Path: lib/features/flora/presentation/providers/camera_screen_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Kita tidak lagi butuh image_picker di sini
// import 'package:image_picker/image_picker.dart';
// import 'package:proyek_flocify/core/services/image_picker_service.dart';

import 'package:proyek_flocify/features/flora/presentation/providers/camera_screen_state.dart';
import 'package:proyek_flocify/features/flora/presentation/providers/flora_providers.dart';

class CameraScreenController extends StateNotifier<CameraScreenState> {
  final Ref _ref;

  CameraScreenController(this._ref) : super(const CameraScreenState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(status: CameraStatus.loading);
    try {
      final repository = _ref.read(floraRepositoryProvider);
      final guides = await repository.getDetectionGuides();
      if (mounted) {
        state = state.copyWith(
          status: CameraStatus.ready,
          guides: guides,
          currentGuideId: guides.isNotEmpty ? guides.first.id : null,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('ERROR _initialize CameraScreen: $e, $stackTrace');
      if (mounted) {
        state = state.copyWith(
          status: CameraStatus.error,
          errorMessage: e.toString(),
        );
      }
    }
  }

  void resetState() {
    state = const CameraScreenState();
    _initialize();
  }

  void selectGuide(String guideId) {
    if (state.status == CameraStatus.ready) {
      state = state.copyWith(currentGuideId: guideId);
    }
  }

  // Method privat untuk menyimpan gambar ke state
  void captureImage(File image) {
    if (state.currentGuideId == null) return;
    final newImages = Map<String, File>.from(state.capturedImages);
    newImages[state.currentGuideId!] = image;
    state = state.copyWith(capturedImages: newImages);
  }

  // Method publik baru yang menggabungkan capture dan auto-next
  void captureAndAdvance(File image) {
    captureImage(image);
    _autoAdvanceToNextStep();
  }

  void removeImage(String guideId) {
    final newImages = Map<String, File>.from(state.capturedImages);
    newImages.remove(guideId);
    state = state.copyWith(capturedImages: newImages);
  }

  Future<void> startAnalysis() async {
    if (state.capturedImages.isEmpty ||
        state.status == CameraStatus.analyzing) {
      return;
    }
    state = state.copyWith(
      status: CameraStatus.analyzing,
      analysisResult: null,
    );
    try {
      final repository = _ref.read(floraRepositoryProvider);
      final images = state.capturedImages.values.toList();
      final result = await repository.analyzeImages(images);
      await repository.saveDetectionToHistory(result);
      if (mounted) {
        state = state.copyWith(
          status: CameraStatus.success,
          analysisResult: result,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('ERROR startAnalysis: $e, $stackTrace');
      if (mounted) {
        state = state.copyWith(
          status: CameraStatus.error,
          errorMessage: 'Gagal melakukan analisis. Silakan coba lagi.',
        );
      }
    }
  }

  void _autoAdvanceToNextStep() {
    final guides = state.guides;
    final captured = state.capturedImages;
    final currentIndex = guides.indexWhere((g) => g.id == state.currentGuideId);

    if (currentIndex == -1) return;

    for (int i = currentIndex + 1; i < guides.length; i++) {
      if (!captured.containsKey(guides[i].id)) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            selectGuide(guides[i].id);
          }
        });
        return;
      }
    }

    for (int i = 0; i < currentIndex; i++) {
      if (!captured.containsKey(guides[i].id)) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            selectGuide(guides[i].id);
          }
        });
        return;
      }
    }
  }
}
