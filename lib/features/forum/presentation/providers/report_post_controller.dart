// lib/features/forum/presentation/providers/report_post_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/forum/presentation/providers/forum_providers.dart';
import 'report_post_state.dart';

final reportPostControllerProvider =
    StateNotifierProvider.autoDispose<ReportPostController, ReportPostState>(
      (ref) => ReportPostController(ref),
    );

class ReportPostController extends StateNotifier<ReportPostState> {
  final Ref _ref;
  ReportPostController(this._ref) : super(const ReportPostState());

  Future<void> submitReport({
    required String postId,
    required String reason,
    String? details,
  }) async {
    state = const ReportPostState(isLoading: true);
    try {
      final repository = _ref.read(forumRepositoryProvider);
      await repository.reportPost(
        postId: postId,
        reason: reason,
        details: details,
      );
      state = const ReportPostState(
        successMessage: 'Laporan berhasil terkirim.',
      );
    } catch (e) {
      state = ReportPostState(errorMessage: e.toString());
    }
  }
}
