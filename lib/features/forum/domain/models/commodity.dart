//lib/features/forum/domain/models/commodity.dart
import 'package:flutter/material.dart';

/// A data class for commodity filter options.
class Commodity {
  final String name;
  final int postCount;
  final IconData iconData;

  const Commodity({
    required this.name,
    required this.postCount,
    required this.iconData,
  });
}
