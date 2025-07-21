// lib/features/home/domain/models/home_pond_status_model.dart
enum PondStatus { critical, warning, normal }

class HomePondStatus {
  final String title;
  final List<String> descriptions;
  final PondStatus status;
  final String commodity;

  HomePondStatus({
    required this.title,
    required this.descriptions,
    required this.status,
    required this.commodity,
  });
}