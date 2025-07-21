// lib/features/forum/presentation/widgets/report_reason_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- 1. TAMBAHKAN IMPORT INI
import '../providers/report_post_controller.dart';
import '../providers/report_post_state.dart';

/// Cara cepat memanggil bottom sheet:
Future<void> openReportReasonSheet(BuildContext ctx, String postId) {
  return showModalBottomSheet(
    context: ctx,
    isScrollControlled: true, // <— penting!
    backgroundColor: Colors.transparent, // biar radius terlihat
    builder: (_) => ReportReasonSheet(postId: postId),
  );
}

/// Stateful‑widget karena kita butuh menyimpan pilihan.
class ReportReasonSheet extends ConsumerStatefulWidget {
  final String postId;
  const ReportReasonSheet({super.key, required this.postId});

  @override
  ConsumerState<ReportReasonSheet> createState() => _ReportReasonSheetState();
}

class _ReportReasonSheetState extends ConsumerState<ReportReasonSheet> {
  final _formKey = GlobalKey<FormState>();
  final _otherReasonController = TextEditingController();
  String? _selectedReason;

  static const _reasons = [
    ('Spam', Icons.report_gmailerrorred_outlined),
    ('Ujaran Kebencian / Pelecehan', Icons.gavel_outlined),
    ('Konten Tidak Relevan', Icons.not_interested_outlined),
    ('Penipuan / Informasi Palsu', Icons.warning_amber_outlined),
    ('Lainnya...', Icons.edit_outlined),
  ];

  // ────────────────────────────────────────────────────────────────────
  // Versi BARU
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final reason = _selectedReason;
    final details = _otherReasonController.text;

    if (reason == null) return;

    ref
        .read(reportPostControllerProvider.notifier)
        .submitReport(
          postId: widget.postId,
          reason: reason,
          details: reason == 'Lainnya...' ? details : null,
        );
  }

  void _showSuccessBanner(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    // Bersihkan banner/snackbar sebelumnya (opsional, biar tidak numpuk)
    messenger
      ..hideCurrentSnackBar()
      ..hideCurrentMaterialBanner();

    final banner = MaterialBanner(
      backgroundColor: Colors.green.shade600,
      elevation: 4,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: const Icon(Icons.check_circle, color: Colors.white),
      content: const Text(
        'Laporan terkirim',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      actions: const [SizedBox.shrink()], // tidak butuh tombol aksi
    );

    messenger.showMaterialBanner(banner);

    // Auto‑dismiss setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      messenger.hideCurrentMaterialBanner();
    });
  }

  // ────────────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOther = _selectedReason == 'Lainnya...';

    ref.listen<ReportPostState>(reportPostControllerProvider, (previous, next) {
      if (next.successMessage != null) {
        Navigator.pop(context); // Tutup bottom sheet
        _showSuccessBanner(context); // Tampilkan banner sukses
      }
      if (next.errorMessage != null) {
        // Opsional: Tampilkan snackbar jika ada error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${next.errorMessage}')));
      }
    });

    return SafeArea(
      top: false, // biar radius atas tetap rapih
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 12,
              // viewInsets = tinggi keyboard ⇒ konten naik otomatis
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag‑handle ────────────────────────────────────────────
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // ── Judul ────────────────────────────────────────────────
                Text(
                  'Mengapa Anda melaporkan postingan ini?',
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // ── Daftar alasan ────────────────────────────────────────
                Flexible(
                  // penting agar bisa scroll jika layar pendek
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _reasons.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (_, i) {
                      final (title, icon) = _reasons[i];
                      return RadioListTile<String>(
                        value: title,
                        groupValue: _selectedReason,
                        onChanged: (val) =>
                            setState(() => _selectedReason = val),
                        title: Text(title),
                        secondary: Icon(icon, size: 20),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),

                // ── Field teks jika "Lainnya" ────────────────────────────
                if (isOther) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _otherReasonController,
                    autofocus: true,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Tuliskan alasan Anda',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (_selectedReason != 'Lainnya...') return null;
                      return (val == null || val.trim().isEmpty)
                          ? 'Alasan tidak boleh kosong'
                          : null;
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // ── Tombol aksi ──────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.send),
                    label: ref.watch(reportPostControllerProvider).isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Kirim Laporan'),
                    onPressed: () {
                      final isLoading = ref
                          .read(reportPostControllerProvider)
                          .isLoading;
                      if (_selectedReason != null && !isLoading) {
                        _submit();
                      } else {
                        null;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
