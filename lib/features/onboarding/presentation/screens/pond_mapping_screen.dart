// lib/features/onboarding/presentation/screens/pond_mapping_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_providers.dart';
import 'pond_config_screen.dart'; // Layar berikutnya

class PondMappingScreen extends ConsumerWidget {
  const PondMappingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController pondCountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Hubungkan Kolam")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Satu alat Flocify dapat mengontrol beberapa kolam sekaligus.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "Alat ini akan dihubungkan ke berapa kolam?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: pondCountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                final count = int.tryParse(pondCountController.text) ?? 0;
                if (count > 0) {
                  // Simpan jumlah kolam ke controller kita
                  ref.read(onboardingControllerProvider.notifier).setTotalPonds(count);

                  // Navigasi ke layar konfigurasi kolam pertama
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PondConfigScreen()),
                  );
                }
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      ),
    );
  }
}