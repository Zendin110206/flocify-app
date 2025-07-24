// Path: lib/core/services/image_picker_service.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}

// Membuat provider untuk service ini agar mudah diakses dari mana saja.
final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerService();
});
