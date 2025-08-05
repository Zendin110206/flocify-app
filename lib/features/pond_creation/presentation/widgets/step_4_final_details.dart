// Path: lib/features/asset_management/tab/pond_creation/presentation/widgets/step_4_final_details.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/pond_creation/domain/models/pond_wizard_state.dart';
import '../../../asset_management/domain/models/asset_models.dart';
import '../../../asset_management/presentation/widgets/device_list_view.dart';
import '../providers/create_pond_provider.dart';

class Step4FinalDetails extends ConsumerWidget {
  const Step4FinalDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(createPondProvider);
    final wizardController = ref.read(createPondProvider.notifier);
    final availableDevices = ref.watch(deviceListProvider);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Detail Akhir',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Berikan nama unik untuk kolam Anda dan hubungkan ke perangkat jika perlu.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        // PERBAIKAN: Melewatkan 'wizardState' ke helper widget
        _buildNameInputCard(context, wizardController, wizardState),
        const SizedBox(height: 24),

        const Text(
          'Pilih Perangkat Monitoring',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),

        // PERBAIKAN: Mengganti nama class _buildDeviceOptionCard menjadi _DeviceOptionCard
        _DeviceOptionCard(
          name: 'Jangan hubungkan perangkat',
          description: 'Gunakan untuk pencatatan manual',
          icon: Icons.edit_note,
          isSelected: wizardState.selectedDevice == null,
          onTap: () => wizardController.selectDevice(null),
        ),

        ...availableDevices.map((device) {
          final isSelected = wizardState.selectedDevice == device.id;
          // PERBAIKAN: Mengganti nama class _buildDeviceOptionCard menjadi _DeviceOptionCard
          return _DeviceOptionCard(
            name: device.name,
            description: 'Sensor: ${device.sensors.join(', ')}',
            icon: Icons.router,
            status: device.status,
            isSelected: isSelected,
            onTap: () => wizardController.selectDevice(device.id),
          );
        }), // PERBAIKAN: Menghapus .toList() yang tidak perlu
      ],
    );
  }

  // PERBAIKAN: Menambahkan parameter PondWizardState
  Widget _buildNameInputCard(
    BuildContext context,
    CreatePondController controller,
    PondWizardState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04*255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Kolam',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            // PERBAIKAN: Mengambil nilai awal dari state, bukan dari controller
            initialValue: state.poolName,
            onChanged: (value) => controller.setPoolName(value),
            decoration: InputDecoration(
              hintText: 'Misal: Kolam Lele Blok A-1',
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
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }
}

// PERBAIKAN: Nama class diubah menjadi UpperCamelCase
class _DeviceOptionCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final DeviceStatus? status;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeviceOptionCard({
    required this.name,
    required this.description,
    required this.icon,
    this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isOnline = status == DeviceStatus.online;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey[200]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withAlpha((255 * 0.04).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withAlpha((255 * 0.1).round())
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? primaryColor : Colors.grey[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? primaryColor
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isOnline ? Colors.green[200]! : Colors.red[200]!,
                    ),
                  ),
                  child: Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOnline ? Colors.green[700] : Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle, color: primaryColor, size: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
