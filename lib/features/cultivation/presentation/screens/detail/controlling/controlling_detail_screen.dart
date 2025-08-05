// lib/features/cultivation/presentation/screens/detail/controlling/controlling_detail_screen.dart

import 'package:flutter/material.dart';

class ControllingDetailScreen extends StatelessWidget {
  // Kita juga akan tambahkan parameter di sini nanti
  const ControllingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Controlling')),
      body: const Center(
        child: Text('Halaman Detail untuk Sistem Controlling'),
      ),
    );
  }
}
