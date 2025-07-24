// Path: lib/features/flora/domain/models/detection_guide.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DetectionGuide extends Equatable {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  // PENAMBAHAN PROPERTI BARU
  final Color color;
  final String exampleImagePath;
  final List<String> tips;

  const DetectionGuide({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.exampleImagePath,
    required this.tips,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    icon,
    color,
    exampleImagePath,
    tips,
  ];
}
