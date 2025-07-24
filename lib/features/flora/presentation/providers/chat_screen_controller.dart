import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/flora/domain/models/analysis_result.dart';
import 'package:proyek_flocify/features/flora/domain/models/chat_message.dart';
import 'package:proyek_flocify/features/flora/presentation/providers/flora_providers.dart';
import 'chat_screen_state.dart';

class ChatScreenController extends StateNotifier<ChatScreenState> {
  final Ref _ref;

  // Flag untuk mencegah inisialisasi ganda
  bool _isChatInitialized = false;

  ChatScreenController(this._ref) : super(const ChatScreenState());

  /// Inisialisasi untuk chat umum (tanpa konteks).
  Future<void> initializeChat() async {
    if (_isChatInitialized) return;
    _isChatInitialized = true;

    state = state.copyWith(status: ChatStatus.loading);
    try {
      final repository = _ref.read(floraRepositoryProvider);
      final initialMessages = await repository.getInitialChat();
      if (mounted) {
        state = state.copyWith(
          status: ChatStatus.ready,
          messages: initialMessages,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: ChatStatus.error,
          errorMessage: e.toString(),
        );
      }
    }
  }

  /// Inisialisasi untuk chat kontekstual setelah analisis.
  void startWithContext(AnalysisResult result, List<File> images) {
    if (_isChatInitialized) return;
    _isChatInitialized = true;

    // 1. Buat pesan pertama yang berisi grid gambar analisis
    final analysisMessage = ChatMessage(
      id: 'bot_context_images_${result.id}',
      text:
          "Analisis foto ikan Anda telah selesai. Berikut adalah hasil visual dari ${images.length} foto yang Anda berikan:",
      author: MessageAuthor.bot,
      timestamp: DateTime.now().subtract(const Duration(seconds: 2)),
      type: MessageType.analysisResult, // Tipe pesan khusus
      analysisImages: images
          .map((file) => file.path)
          .toList(), // Sertakan path gambar
    );

    // 2. Buat pesan kedua yang berisi teks hasil analisis
    final textMessage = ChatMessage(
      id: 'bot_context_text_${result.id}',
      text:
          "Berdasarkan analisis, terdeteksi '${result.fishType}' Anda dalam kondisi '${result.healthStatus}'.\n\nApa ada detail dari rekomendasi atau gejala yang ingin Anda tanyakan lebih lanjut?",
      author: MessageAuthor.bot,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      status: ChatStatus.ready,
      messages: [analysisMessage, textMessage],
    );
  }

  /// Mengirim pesan baru dan menunggu balasan bot.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.status == ChatStatus.submitting) return;

    final userMessage = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      author: MessageAuthor.user,
      timestamp: DateTime.now(),
    );

    // Update UI secara optimis dengan pesan pengguna dan aktifkan indikator "mengetik"
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    try {
      final repository = _ref.read(floraRepositoryProvider);
      // Simulasi panggil API
      final botReply = await repository.sendMessage(text: userMessage.text);

      // Tambahkan balasan bot dan matikan indikator "mengetik"
      if (mounted) {
        state = state.copyWith(
          messages: [...state.messages, botReply],
          isTyping: false,
        );
      }
    } catch (e) {
      final errorReply = ChatMessage(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        text: "Maaf, terjadi kesalahan. Coba beberapa saat lagi.",
        author: MessageAuthor.bot,
        timestamp: DateTime.now(),
      );
      if (mounted) {
        state = state.copyWith(
          messages: [...state.messages, errorReply],
          isTyping: false, // Pastikan isTyping mati saat error
        );
      }
    }
  }
}
