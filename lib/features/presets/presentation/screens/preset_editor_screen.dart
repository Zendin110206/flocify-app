// lib/features/presets/presentation/screens/preset_editor_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'preset_list_screen.dart';

// Kelas helper sederhana untuk mendefinisikan sebuah parameter
class ParameterDefinition {
  final String name;
  final String unit;
  const ParameterDefinition({required this.name, required this.unit});
}

// Inilah "Sumber Kebenaran" kita.
// Jika ingin menambah parameter baru, cukup tambahkan di sini.
const List<ParameterDefinition> kAvailableParameters = [
  ParameterDefinition(name: 'pH', unit: ''),
  ParameterDefinition(name: 'Suhu', unit: '°C'),
  ParameterDefinition(name: 'Amonia', unit: 'mg/L'),
  ParameterDefinition(name: 'Oksigen', unit: 'mg/L'),
  ParameterDefinition(name: 'Salinitas', unit: 'ppt'),
  ParameterDefinition(name: 'Nitrit', unit: 'mg/L'),
  ParameterDefinition(name: 'Alkalinitas', unit: 'ppm'),
];

const double _kAppBarHeight = 72.0;

class PresetEditorScreen extends ConsumerStatefulWidget {
  final Preset? preset;
  const PresetEditorScreen({super.key, this.preset});

  @override
  ConsumerState<PresetEditorScreen> createState() => _PresetEditorScreenState();
}

class _PresetEditorScreenState extends ConsumerState<PresetEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late final TextEditingController _nameController;
  late final TextEditingController _commodityController;
  late final TextEditingController _descriptionController;
  late List<PresetParameter> _parameters;

  bool _isLoading = false;
  bool get _isEditing => widget.preset != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.preset?.name ?? '');
    _commodityController = TextEditingController(
      text: widget.preset?.commodity ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.preset?.description ?? '',
    );
    _parameters =
        widget.preset?.parameters.map((p) => p.copyWith()).toList() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commodityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---

  void _addParameter() {
    setState(() {
      _parameters.add(
        PresetParameter(id: _uuid.v4(), name: '', min: 0, max: 0, unit: ''),
      );
    });
  }

  void _removeParameter(String id) {
    setState(() {
      _parameters.removeWhere((p) => p.id == id);
    });
  }

  void _updateParameter(int index, PresetParameter newParam) {
    setState(() {
      _parameters[index] = newParam;
    });
  }

  Future<void> _savePreset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_parameters.isEmpty) {
      _showErrorSnackBar('Tambahkan minimal satu parameter');
      return;
    }
    for (final param in _parameters) {
      if (param.name.isEmpty) {
        _showErrorSnackBar('Semua nama parameter harus dipilih');
        return;
      }
      if (param.min >= param.max) {
        _showErrorSnackBar(
          'Nilai minimum harus lebih kecil dari maksimum untuk parameter "${param.name}"',
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final newPreset = Preset(
        id: widget.preset?.id ?? _uuid.v4(),
        name: _nameController.text.trim(),
        commodity: _commodityController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        creator: PresetCreator.user,
        parameters: _parameters,
      );

      if (_isEditing) {
        await ref.read(presetListProvider.notifier).updatePreset(newPreset);
      } else {
        await ref.read(presetListProvider.notifier).addPreset(newPreset);
      }

      if (mounted) {
        _showSuccessSnackBar(
          'Preset "${newPreset.name}" berhasil ${_isEditing ? 'diperbarui' : 'dibuat'}',
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Terjadi kesalahan saat menyimpan preset');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  // --- UI BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: AppSpacing.md),
              _buildParametersSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    const int subtitleAlpha = 217;
    const int borderAlpha = 51;

    return AppBar(
      backgroundColor: AppColors.appBarSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: AppColors.textOnDark),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEditing ? 'Edit Preset' : 'Buat Preset Baru',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textOnDark,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Lengkapi detail preset',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textOnDark.withAlpha(subtitleAlpha),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      toolbarHeight: _kAppBarHeight,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: TextButton(
            onPressed: _isLoading ? null : _savePreset,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textOnDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: AppColors.textOnDark.withAlpha(borderAlpha),
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Informasi Dasar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildTextField(
            controller: _nameController,
            label: 'Nama Preset',
            hint: 'Contoh: Lele Kolam Terpal',
            icon: Icons.label_outline,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: _commodityController,
            label: 'Komoditas',
            hint: 'Contoh: Lele, Nila, Udang',
            icon: Icons.waves_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: _descriptionController,
            label: 'Deskripsi (Opsional)',
            hint: 'Jelaskan kegunaan preset',
            icon: Icons.description_outlined,
            maxLines: 3,
            isOptional: true,
          ),
        ],
      ),
    );
  }

  Widget _buildParametersSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: Text(
                  'Parameter Kualitas Air',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${_parameters.length} Parameter',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ..._parameters.asMap().entries.map((entry) {
            final index = entry.key;
            final param = entry.value;
            return _ParameterCard(
              parameter: param,
              index: index,
              onUpdate: (newParam) => _updateParameter(index, newParam),
              onRemove: () => _removeParameter(param.id),
            );
          }),
          if (_parameters.isNotEmpty) const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addParameter,
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Tambah Parameter',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool isOptional = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: 1,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        hintStyle: const TextStyle(fontSize: 15, color: AppColors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
      validator: (value) {
        if (isOptional) return null;
        if (value == null || value.trim().isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}

class _ParameterCard extends StatelessWidget {
  final PresetParameter parameter;
  final int index;
  final ValueChanged<PresetParameter> onUpdate;
  final VoidCallback onRemove;

  const _ParameterCard({
    required this.parameter,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: Text(
                  'Parameter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.danger,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.danger.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            value: parameter.name.isEmpty ? null : parameter.name,
            hint: const Text(
              'Pilih Parameter',
              style: TextStyle(color: AppColors.textTertiary),
            ),
            items: kAvailableParameters
                .map(
                  (paramDef) => DropdownMenuItem(
                    value: paramDef.name,
                    child: Text(paramDef.name),
                  ),
                )
                .toList(),

            onChanged: (value) {
              if (value == null) return;

              // Cari definisi lengkap dari parameter yang dipilih
              final selectedDefinition = kAvailableParameters.firstWhere(
                (p) => p.name == value,
                // Fallback jika tidak ditemukan (seharusnya tidak akan terjadi)
                orElse: () => const ParameterDefinition(name: '', unit: ''),
              );

              // Panggil onUpdate dengan nama BARU dan unit OTOMATIS
              onUpdate(
                parameter.copyWith(name: value, unit: selectedDefinition.unit),
              );
            },
            decoration: _inputDecoration(),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildNumericField(
                  label: 'Min',
                  initialValue: parameter.min,
                  onChanged: (val) => onUpdate(parameter.copyWith(min: val)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildNumericField(
                  label: 'Max',
                  initialValue: parameter.max,
                  onChanged: (val) => onUpdate(parameter.copyWith(max: val)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildUnitField(
                  initialValue: parameter.unit,
                  onChanged: (val) => onUpdate(parameter.copyWith(unit: val)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }

  Widget _buildNumericField({
    required String label,
    required double initialValue,
    required ValueChanged<double> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue.toString(),
      decoration: _inputDecoration(label: label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) => onChanged(double.tryParse(value) ?? 0),
    );
  }

  Widget _buildUnitField({
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      // highlight-start
      key: Key(
        initialValue,
      ), // Kunci penting agar field di-rebuild saat unit berubah
      initialValue: initialValue,
      readOnly: true, // Membuat field tidak bisa diketik
      // highlight-end
      decoration: _inputDecoration(label: 'Unit').copyWith(
        // Sedikit ubah warna latar untuk menandakan field ini non-aktif
        fillColor: AppColors.background,
      ),
      // Kita tidak butuh onChanged lagi, tapi biarkan untuk struktur
      // onChanged: onChanged,
    );
  }
}
