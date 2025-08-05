// Path: lib/features/device_registration/presentation/widgets/device_config_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Nantinya, state ini akan dikelola oleh provider/controller
class DeviceConfigBottomSheet extends ConsumerStatefulWidget {
  const DeviceConfigBottomSheet({super.key});

  @override
  ConsumerState<DeviceConfigBottomSheet> createState() =>
      _DeviceConfigBottomSheetState();
}

class _DeviceConfigBottomSheetState
    extends ConsumerState<DeviceConfigBottomSheet> {
  final _deviceNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // State sementara untuk sensor
  final Map<String, bool> _sensors = {
    'pH Meter': false,
    'Sensor Suhu': false,
    'Sensor Amonia': false,
    'Sensor Oksigen': false,
    'Sensor Keruhan': false,
  };

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  void _registerDevice() {
    if (!_formKey.currentState!.validate()) return;

    final selectedSensors = _sensors.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedSensors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu sensor yang terpasang.'),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    Navigator.pop(context); // Tutup bottom sheet
    // TODO: Panggil provider untuk mendaftarkan perangkat ke backend
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    // ... (Kode dialog sukses akan kita tambahkan)
    // Untuk sekarang, kita kembali ke halaman aset
    Navigator.of(context).pop(); // Ini akan pop halaman Scan QR
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding untuk keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header (Handle & Judul)
            _buildHeader(),
            // Konten (Bisa di-scroll)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildDeviceNameInput(),
                        const SizedBox(height: 32),
                        _buildSensorConfiguration(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Footer (Tombol Aksi)
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.router,
                  color: Color(0xFF2563EB),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Perangkat Terdeteksi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1f2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: FLC-2024-A7B9C3',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nama Perangkat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1f2937),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _deviceNameController,
          decoration: InputDecoration(
            hintText: 'Misal: Alat Kolam Utama',
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2563EB)),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama perangkat tidak boleh kosong.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSensorConfiguration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Konfigurasi Sensor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1f2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih sensor yang telah Anda pasang pada perangkat',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        ..._sensors.keys.map((sensorName) => _buildSensorTile(sensorName)),
      ],
    );
  }

  Widget _buildSensorTile(String name) {
    final isSelected = _sensors[name]!;
    final icons = {
      'pH Meter': Icons.science_outlined,
      'Sensor Suhu': Icons.thermostat,
      'Sensor Amonia': Icons.air,
      'Sensor Oksigen': Icons.bubble_chart_outlined,
      'Sensor Keruhan': Icons.opacity,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF2563EB).withAlpha((0.05 * 255).round())
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF2563EB).withAlpha((0.3 * 255).round())
              : Colors.grey[300]!,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFF1f2937),
          ),
        ),
        secondary: Icon(
          icons[name] ?? Icons.sensors,
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey[600],
        ),
        value: isSelected,
        onChanged: (value) => setState(() => _sensors[name] = value ?? false),
        activeColor: const Color(0xFF2563EB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // === GANTI SELURUH ISI METHOD INI ===
  Widget _buildActionButtons() {
    return Container(
      // Dekorasi (shadow, warna) tetap di luar
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      // Gunakan SafeArea untuk membungkus konten di dalamnya
      child: SafeArea(
        // Kita hanya perlu safe area untuk bagian atas (jika ada notch di mode landscape) dan bawah
        top: false,
        child: Padding(
          // Beri padding horizontal
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _registerDevice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Daftarkan Perangkat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
