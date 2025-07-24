import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:proyek_flocify/features/flora/domain/models/chat_message.dart';

part 'chat_screen_state.freezed.dart';

// Enum untuk status halaman chat
enum ChatStatus { initial, loading, ready, submitting, error }

@freezed
class ChatScreenState with _$ChatScreenState {
  const factory ChatScreenState({
    // Status halaman untuk mengontrol UI
    @Default(ChatStatus.initial) ChatStatus status,

    // Daftar semua pesan yang akan ditampilkan di layar
    @Default([]) List<ChatMessage> messages,

    // --- STATE BARU ---
    // Status untuk menunjukkan apakah bot sedang "mengetik" balasan.
    @Default(false) bool isTyping,
    // ------------------

    // Pesan error jika terjadi masalah
    String? errorMessage,
  }) = _ChatScreenState;
}
