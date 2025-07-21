// lib/features/onboarding/presentation/screens/farmer_profile_screen.dart

import 'package:flutter/material.dart';
import 'pond_mapping_screen.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Budidaya Anda')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sedikit lagi! Informasi ini membantu kami memberikan rekomendasi terbaik untuk Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Contoh satu input, yang lain bisa mengikuti pola yang sama
            const Text(
              'Apa tingkat pengalaman Anda?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              items: ['Pemula', 'Menengah', 'Ahli']
                  .map(
                    (label) =>
                        DropdownMenuItem(value: label, child: Text(label) ),
                  )
                  .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),

            const Text(
              'Apa skala usaha Anda saat ini?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              items:
                  [
                        'Hobi / Sampingan',
                        'Usaha Utama (<10 kolam)',
                        'Skala Besar (>10 kolam)',
                      ]
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label) ),
                      )
                      .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),

            const Text(
              'Apa tantangan terbesar Anda?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              items:
                  ['Biaya Pakan', 'Penyakit Ikan', 'Kualitas Air', 'Pemasaran']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label) ),
                      )
                      .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 48),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // TODO: Simpan data profil
                print('Data profil disimpan!');

                // Navigasi ke langkah berikutnya (Pemetaan Kolam)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PondMappingScreen(),
                  ),
                );
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      ),
    );
  }
}
