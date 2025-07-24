import 'package:equatable/equatable.dart';

/// Enum untuk membedakan jenis pesan di UI.
/// - [text]: Pesan teks biasa.
/// - [analysisResult]: Pesan khusus dari bot yang menampilkan ringkasan
///   dan thumbnail gambar hasil analisis.
enum MessageType { text, analysisResult }

/// Enum untuk mengidentifikasi pengirim pesan.
enum MessageAuthor { user, bot }

/// Model data untuk sebuah pesan dalam percakapan.
/// Menggunakan Equatable untuk perbandingan objek yang efisien.
class ChatMessage extends Equatable {
  final String id;
  final String text;
  final MessageAuthor author;
  final DateTime timestamp;
  final MessageType type;

  /// Daftar path gambar lokal yang terkait dengan pesan hasil analisis.
  final List<String>? analysisImages;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.author,
    required this.timestamp,
    this.type = MessageType.text,
    this.analysisImages,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    author,
    timestamp,
    type,
    analysisImages,
  ];
}
