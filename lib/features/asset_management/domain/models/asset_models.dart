// lib/features/asset_management/domain/models/asset_models.dart

// --- Device Models ---
class DeviceModel {
  final String id;
  final String name;
  final DeviceStatus status;
  final List<String> sensors;
  final String lastSeen;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.status,
    required this.sensors,
    required this.lastSeen,
  });
}

enum DeviceStatus { online, offline }

// --- Pond Models ---
class PondModel {
  final String id;
  final String name;
  final String commodity;
  final String? connectedDevice;
  final String area;
  final PondStatus status;
  final int fishCount;

  const PondModel({
    required this.id,
    required this.name,
    required this.commodity,
    this.connectedDevice,
    required this.area,
    required this.status,
    required this.fishCount,
  });
}

enum PondStatus { healthy, warning, disconnected }
