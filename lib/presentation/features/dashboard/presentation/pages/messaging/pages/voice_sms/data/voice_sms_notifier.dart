import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/voice_sms/data/voice_sms_repository.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/voice_sms/data/voice_sms_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/voice_sms/data/voice_sms_senderid_request.dart';

class VoiceSmsState {
  const VoiceSmsState({
    this.isSending = false,
    this.isLoadingSenderIds = false,
    this.senderIds = const [],
    this.errorMessage,
    this.successMessage,
  });

  final bool isSending;
  final bool isLoadingSenderIds;
  final List<String> senderIds;
  final String? errorMessage;
  final String? successMessage;

  VoiceSmsState copyWith({
    bool? isSending,
    bool? isLoadingSenderIds,
    List<String>? senderIds,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return VoiceSmsState(
      isSending: isSending ?? this.isSending,
      isLoadingSenderIds: isLoadingSenderIds ?? this.isLoadingSenderIds,
      senderIds: senderIds ?? this.senderIds,
      errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearMessages ? null : successMessage ?? this.successMessage,
    );
  }
}

class VoiceSmsNotifier extends StateNotifier<VoiceSmsState> {
  VoiceSmsNotifier(this._repository) : super(const VoiceSmsState());

  final VoiceSmsRepository _repository;

  Future<void> fetchSenderIds() async {
    state = state.copyWith(isLoadingSenderIds: true, clearMessages: true);
    try {
      final response = await _repository.getServiceSenderId(
        const GetServiceSenderIdRequest(),
      );
      if (response.status) {
        state = state.copyWith(
          isLoadingSenderIds: false,
          senderIds: _extractSenderIds(response.data),
        );
      } else {
        state = state.copyWith(
          isLoadingSenderIds: false,
          errorMessage: response.displayMessage,
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoadingSenderIds: false,
        errorMessage: _dioErrorMessage(e),
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingSenderIds: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  /// Returns true on success so the view can reset its form.
  Future<bool> sendVoiceSms({
    required String from,
    required String recipient,
    required String message,
    String scheduleDate = '',
  }) async {
    state = state.copyWith(isSending: true, clearMessages: true);
    try {
      final response = await _repository.sendVoiceSms(
        SendVoiceSmsRequest(
          from: from,
          recipient: recipient,
          message: message,
          scheduleDate: scheduleDate,
        ),
      );
      if (response.status) {
        state = state.copyWith(
          isSending: false,
          successMessage: response.serverMessage.isNotEmpty
              ? response.serverMessage
              : 'Voice SMS sent successfully.',
        );
        return true;
      } else {
        state = state.copyWith(
          isSending: false,
          errorMessage: response.displayMessage,
        );
        return false;
      }
    } on DioException catch (e) {
      state =
          state.copyWith(isSending: false, errorMessage: _dioErrorMessage(e));
      return false;
    } catch (_) {
      state = state.copyWith(
        isSending: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  List<String> _extractSenderIds(List<dynamic> raw) {
    return raw
        .map((item) {
          if (item is String) return item;
          if (item is Map) {
            return (item['sender_id'] ?? item['name'] ?? item['id'] ?? '')
                .toString();
          }
          return item.toString();
        })
        .where((id) => id.isNotEmpty)
        .toList();
  }

  String _dioErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic> &&
        (data['server_message'] as String?)?.isNotEmpty == true) {
      return data['server_message'].toString();
    }
    return e.message ??
        'Network error. Please check your connection and try again.';
  }
}

final voiceSmsNotifierProvider =
    StateNotifierProvider<VoiceSmsNotifier, VoiceSmsState>((ref) {
  final repository = ref.watch(voiceSmsRepositoryProvider);
  return VoiceSmsNotifier(repository);
});
