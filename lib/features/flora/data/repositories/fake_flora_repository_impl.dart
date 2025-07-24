// Path: lib/features/flora/data/repositories/fake_flora_repository_impl.dart

import 'package:flutter/material.dart';
import 'dart:io';
import '../../domain/models/detection_history.dart';
import '../../domain/models/detection_guide.dart';
import '../../domain/models/analysis_result.dart';
import '../../domain/repositories/flora_repository.dart';
import '../../domain/models/chat_message.dart';

class FakeFloraRepository implements FloraRepository {
  // Data dummy yang tadinya ada di HistoryScreen, sekarang pindah ke sini.
  final List<DetectionHistory> _dummyHistory = [
    DetectionHistory(
      id: '1',
      fishType: 'Ikan Nila',
      healthStatus: 'Sehat',
      confidence: 85,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      imageUrl: 'assets/images/dump1.png',
      symptoms: [],
      recommendations: ['Pertahankan kualitas air', 'Pemberian pakan teratur'],
    ),
    DetectionHistory(
      id: '2',
      fishType: 'Ikan Lele',
      healthStatus: 'Terinfeksi',
      confidence: 78,
      date: DateTime.now().subtract(const Duration(days: 1)),
      imageUrl: 'assets/images/dump2.png',
      symptoms: ['Bintik putih pada kulit', 'Nafsu makan berkurang'],
      recommendations: [
        'Isolasi ikan',
        'Gunakan obat antijamur',
        'Perbaiki kualitas air',
      ],
    ),
  ];

  @override
  Future<List<DetectionHistory>> getDetectionHistory() async {
    // Simulasi jeda jaringan
    await Future.delayed(const Duration(seconds: 1));
    return _dummyHistory;
  }

  @override
  Future<DetectionHistory> getDetectionDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _dummyHistory.firstWhere((item) => item.id == id);
  }

  @override
  Future<List<DetectionGuide>> getDetectionGuides() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulasi network
    return const [
      DetectionGuide(
        id: 'overview',
        title: 'Overview',
        description:
            'Ambil foto keseluruhan ikan dari jarak sedang dengan pencahayaan yang baik',
        icon: Icons.photo_camera,
        color: Color(0xFF6366F1),
        exampleImagePath: 'assets/images/dump1.png',
        tips: [
          'Pastikan seluruh tubuh ikan terlihat dalam frame',
          'Gunakan pencahayaan yang cukup dan merata',
          'Jaga jarak sekitar 30-50 cm dari ikan',
        ],
      ),
      DetectionGuide(
        id: 'close_up',
        title: 'Close-up',
        description:
            'Foto detail bagian yang bermasalah atau mencurigakan pada tubuh ikan',
        icon: Icons.zoom_in,
        color: Color(0xFF8B5CF6),
        exampleImagePath: 'assets/images/dump2.png',
        tips: [
          'Fokuskan pada area yang terlihat tidak normal',
          'Pastikan gambar tidak blur atau kabur',
          'Ambil dari jarak 10-20 cm untuk detail maksimal',
        ],
      ),
      DetectionGuide(
        id: 'side_view',
        title: 'Side View',
        description:
            'Ambil foto dari samping untuk melihat bentuk tubuh dan postur ikan',
        icon: Icons.flip_camera_android,
        color: Color(0xFF06B6D4),
        exampleImagePath: 'assets/images/dump3.png',
        tips: [
          'Posisikan ikan secara horizontal di frame',
          'Pastikan profil tubuh terlihat jelas',
          'Hindari sudut yang terlalu miring',
        ],
      ),
      DetectionGuide(
        id: 'fins_gills',
        title: 'Fins & Gills',
        description:
            'Fokus pada sirip dan insang untuk deteksi penyakit atau kelainan',
        icon: Icons.waves,
        color: Color(0xFF10B981),
        exampleImagePath: 'assets/images/dump1.png',
        tips: [
          'Buka penutup insang dengan hati-hati jika memungkinkan',
          'Pastikan sirip dalam kondisi terbuka',
          'Perhatikan warna dan tekstur insang',
        ],
      ),
    ];
  }

  @override
  Future<List<ChatMessage>> getInitialChat() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ChatMessage(
        id: 'init_bot_1',
        text:
            "Halo! Saya FLORA AI. Unggah foto ikan Anda dan ceritakan keluhannya, saya akan bantu menganalisisnya.",
        author: MessageAuthor.bot,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }

  @override
  Future<void> saveDetectionToHistory(AnalysisResult result) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulasi menyimpan

    // Konversi AnalysisResult menjadi DetectionHistory
    final newHistory = DetectionHistory(
      id: result.id,
      fishType: result.fishType,
      healthStatus: result.healthStatus,
      // Kita asumsikan confidence di model history adalah integer
      confidence: (result.confidence * 100).toInt(),
      date: DateTime.now(),
      // Gunakan path gambar dari hasil analisis
      imageUrl: result.imageUrl,
      symptoms: result.symptoms,
      recommendations: result.recommendations,
    );

    // Tambahkan ke daftar dummyHistory di paling atas
    _dummyHistory.insert(0, newHistory);
    print('Deteksi baru telah disimpan ke riwayat palsu.');
  }

  // IMPLEMENTASI sendMessage YANG DISESUAIKAN
  @override
  Future<ChatMessage> sendMessage({
    required String text,
    List<File>? images,
    String? analysisContextId, // <-- Parameter baru
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    String replyText;

    // Logika untuk pesan pembuka kontekstual
    if (analysisContextId != null) {
      replyText =
          "Saya telah menerima hasil analisis Anda dengan ID: $analysisContextId. Terdeteksi ikan Anda dalam kondisi '${'Sehat'}'. Apa ada detail yang ingin Anda tanyakan lebih lanjut?";
    } else if (images != null && images.isNotEmpty) {
      replyText =
          "Terima kasih telah mengirimkan ${images.length} gambar. Berdasarkan analisis awal, terlihat ada indikasi stres pada ikan. Bisakah Anda jelaskan lebih lanjut?";
    } else if (text.toLowerCase().contains("pakan")) {
      replyText =
          "Terkait pakan, pastikan Anda memberikan pakan berkualitas dengan kandungan protein yang sesuai untuk jenis dan usia ikan Anda. Jangan memberi pakan berlebihan.";
    } else {
      replyText =
          "Saya menerima pesan Anda. Untuk analisis yang lebih akurat, mohon mulai sesi deteksi dari halaman utama.";
    }

    return ChatMessage(
      id: 'bot_reply_${DateTime.now().millisecondsSinceEpoch}',
      text: replyText,
      author: MessageAuthor.bot,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<AnalysisResult> analyzeImages(List<File> images) async {
    // Simulasi proses analisis AI yang memakan waktu
    await Future.delayed(const Duration(seconds: 3));

    // Simulasi hasil dari backend. Ini adalah data palsu yang akan kita gunakan
    // untuk membangun UI di halaman hasil.
    // Kita asumsikan gambar pertama adalah gambar utama.
    final mainImage = images.isNotEmpty
        ? images.first.path
        : 'assets/images/dump1.png';

    // Mengembalikan objek AnalysisResult yang sesuai dengan model kita.
    return AnalysisResult(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      fishType: 'Ikan Nila',
      healthStatus: 'Sehat',
      confidence: 0.85, // 85%
      symptoms: [],
      recommendations: [
        'Kualitas air sudah baik, pertahankan!',
        'Jadwal pakan sudah sesuai, lanjutkan.',
        'Monitor suhu air secara berkala.',
      ],
      // Kita gunakan path dari gambar nyata jika ada, jika tidak, pakai gambar dump
      imageUrl: mainImage,
    );
  }
}
