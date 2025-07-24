// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proyek_flocify/core/screens/auth_wrapper.dart'; // import baru
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart'; // Untuk mengecek mode debug

void main() async {
  Logger.root.level = Level.ALL; // Atur level logging
  Logger.root.onRecord.listen((record) {
    // Tampilkan log HANYA saat dalam mode debug
    if (kDebugMode) {
      print(
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
      );
    }
  });

  // Penjelasan: Kode ini memerintahkan aplikasi: "Setiap kali ada pesan log dari mana pun di aplikasi, tampilkan pesan itu ke konsol, tapi hanya jika aplikasi sedang dalam mode debug." Dengan begini, log tidak akan muncul saat aplikasi sudah di-rilis.


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('id_ID', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flocify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'), // Indonesia
      ],
      // Di sini kita memberitahu aplikasi bahwa halaman pertamanya
      // adalah LoginPage yang sudah kita buat.
      home: const AuthWrapper(),
    );
  }
}
