// lib/features/forum/presentation/providers/report_post_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_post_state.freezed.dart';

@freezed
class ReportPostState with _$ReportPostState {
  const factory ReportPostState({
    @Default(false) bool isLoading,
    String? successMessage,
    String? errorMessage,
  }) = _ReportPostState;
}
