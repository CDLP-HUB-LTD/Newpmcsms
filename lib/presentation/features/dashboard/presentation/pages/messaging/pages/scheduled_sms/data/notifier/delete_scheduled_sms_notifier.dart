// lib/presentation/features/dashboard/presentation/pages/messaging/presentation/notifier/delete_scheduled_sms_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/delete_scheduled_message_request.dart';
import '../../data/repository/scheduled_sms_repository.dart';

class DeleteScheduledSmsState {
  final bool isLoading;
  const DeleteScheduledSmsState({this.isLoading = false});
}

class DeleteScheduledSmsNotifier
    extends AutoDisposeNotifier<DeleteScheduledSmsState> {
  DeleteScheduledSmsNotifier();

  late ScheduledSmsRepository _repository;

  @override
  DeleteScheduledSmsState build() {
    _repository = ref.read(scheduledSmsRepositoryProvider);
    return const DeleteScheduledSmsState();
  }

  Future<void> deleteScheduledSms({
    required DeleteScheduledMessageRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = const DeleteScheduledSmsState(isLoading: true);
    try {
      final value = await _repository.deleteScheduledSms(data);
      if (!value.status) throw value.serverMessage.toString();
      state = const DeleteScheduledSmsState(isLoading: false);
      onSuccess(value.data?.serverMessage ?? 'Schedule cancelled successfully');
    } catch (e) {
      state = const DeleteScheduledSmsState(isLoading: false);
      onError(e.toString());
    }
  }
}

final deleteScheduledSmsNotifier = NotifierProvider.autoDispose<
    DeleteScheduledSmsNotifier, DeleteScheduledSmsState>(
  DeleteScheduledSmsNotifier.new,
);
