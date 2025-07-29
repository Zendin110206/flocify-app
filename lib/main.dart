// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

import 'package:proyek_flocify/firebase_options.dart';
import 'package:proyek_flocify/core/screens/auth_wrapper.dart';

void main() async {
  // Atur level logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
      );
    }
  });

  // Pastikan semua binding framework siap sebelum menjalankan kode async.
  WidgetsFlutterBinding.ensureInitialized();

  // BLOK KODE INI UNTUK MENGUNCI ORIENTASI, CUMAN VERTIKAL DOANK
  // =======================================================
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // =======================================================

  // Muat environment variables dari file .env
  await dotenv.load(fileName: ".env");

  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi format tanggal untuk lokalisasi Indonesia
  await initializeDateFormatting('id_ID', null);

  // Jalankan aplikasi dengan Riverpod sebagai root
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
      // Gerbang utama aplikasi adalah AuthWrapper
      home: const AuthWrapper(),
    );
  }
}
