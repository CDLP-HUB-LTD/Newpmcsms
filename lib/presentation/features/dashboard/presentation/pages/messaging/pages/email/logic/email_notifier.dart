// lib/presentation/features/email/logic/email_notifier.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/email/data/repository/email_repository.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/email/data/send_bulk_email_request.dart';

class EmailState {
  final bool isSending;
  final bool isLoadingSenderIds;
  final List<String> senderIds;
  final String? errorMessage;

  const EmailState({
    this.isSending = false,
    this.isLoadingSenderIds = false,
    this.senderIds = const [],
    this.errorMessage,
  });

  EmailState copyWith({
    bool? isSending,
    bool? isLoadingSenderIds,
    List<String>? senderIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EmailState(
      isSending: isSending ?? this.isSending,
      isLoadingSenderIds: isLoadingSenderIds ?? this.isLoadingSenderIds,
      senderIds: senderIds ?? this.senderIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class EmailNotifier extends StateNotifier<EmailState> {
  final EmailRepository _repository;
  EmailNotifier(this._repository) : super(const EmailState());

  Future<void> fetchSenderIds() async {
    state = state.copyWith(isLoadingSenderIds: true, clearError: true);
    try {
      final response = await _repository.getSenderIds(service: 'email');
      if (response.status) {
        state = state.copyWith(
          isLoadingSenderIds: false,
          senderIds: response.data.map((e) => e.toString()).toList(),
        );
      } else {
        state = state.copyWith(
          isLoadingSenderIds: false,
          errorMessage: response.serverMessage ?? 'Failed to load sender IDs',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoadingSenderIds: false,
        errorMessage: e.response?.data?['server_message']?.toString() ??
            e.message ??
            'Network error',
      );
    }
  }

  /// Returns true on success, false otherwise. Check [EmailState.errorMessage]
  /// for the server-provided reason on failure.
  Future<bool> sendBulkEmail({
    required String senderId,
    required String subject,
    required String message,
    required String recipients,
  }) async {
    state = state.copyWith(isSending: true, clearError: true);
    try {
      final response = await _repository.sendBulkEmail(
        SendBulkEmailRequest(
          senderId: senderId,
          subject: subject,
          message: message,
          recipients: recipients,
        ),
      );
      state = state.copyWith(
        isSending: false,
        errorMessage: response.status ? null : response.serverMessage,
        clearError: response.status,
      );
      return response.status;
    } on DioException catch (e) {
      state = state.copyWith(
        isSending: false,
        errorMessage: e.response?.data?['server_message']?.toString() ??
            e.message ??
            'Network error',
      );
      return false;
    }
  }
}

final emailNotifierProvider =
    StateNotifierProvider<EmailNotifier, EmailState>((ref) {
  return EmailNotifier(ref.watch(emailRepositoryProvider));
});
