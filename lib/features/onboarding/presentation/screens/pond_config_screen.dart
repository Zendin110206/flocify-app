// lib/features/onboarding/presentation/screens/pond_config_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_providers.dart';

class PondConfigScreen extends ConsumerStatefulWidget {
  const PondConfigScreen({super.key});

  @override
  ConsumerState<PondConfigScreen> createState() => _PondConfigScreenState();
}

class _PondConfigScreenState extends ConsumerState<PondConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salesTargetController = TextEditingController();
  String? _selectedCommodity;
  String? _selectedPondType;

  @override
  void dispose() {
    _salesTargetController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Validasi form
    if (_formKey.currentState!.validate()) {
      // Kumpulkan data
      final configData = PondConfigData(
        commodity: _selectedCommodity!,
        pondType: _selectedPondType!,
        salesTarget: double.tryParse(_salesTargetController.text) ?? 0,
      );

      // Panggil controller untuk memproses data & state
      ref
          .read(onboardingControllerProvider.notifier)
          .completePondConfiguration(configData);

      final state = ref.read(onboardingControllerProvider);
      final currentIndex = state.currentPondIndex;
      final totalPonds = state.totalPonds;

      // Navigasi
      if (currentIndex < totalPonds) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PondConfigScreen()),
        );
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final totalPonds = state.totalPonds;
    final currentIndex = state.currentPondIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text('Konfigurasi Kolam $currentIndex dari $totalPonds'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCommodity,
                items: ['Lele', 'Nila', 'Udang Vaname']
                    .map(
                      (label) =>
                          DropdownMenuItem(value: label, child: Text(label)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCommodity = value),
                decoration: const InputDecoration(
                  labelText: 'Pilih Komoditas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedPondType,
                items: ['Kolam Bundar', 'Kolam Kotak']
                    .map(
                      (label) =>
                          DropdownMenuItem(value: label, child: Text(label)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedPondType = value),
                decoration: const InputDecoration(
                  labelText: 'Jenis Kolam',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _salesTargetController,
                decoration: const InputDecoration(
                  labelText: 'Target Penjualan /Kg',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value ?? '').isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 48),
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _submitForm,
                child: Text(
                  currentIndex < totalPonds
                      ? 'Lanjutkan ke Kolam Berikutnya'
                      : 'Selesai',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
