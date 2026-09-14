// lib/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/update_scheduled_sms_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/update_scheduled_message_request.dart';
import '../../data/repository/scheduled_sms_repository.dart';

class UpdateScheduledSmsState {
  final bool isLoading;
  const UpdateScheduledSmsState({this.isLoading = false});
}

class UpdateScheduledSmsNotifier
    extends AutoDisposeNotifier<UpdateScheduledSmsState> {
  UpdateScheduledSmsNotifier();

  late ScheduledSmsRepository _repository;

  @override
  UpdateScheduledSmsState build() {
    _repository = ref.read(scheduledSmsRepositoryProvider);
    return const UpdateScheduledSmsState();
  }

  Future<void> updateScheduledSms({
    required UpdateScheduledMessageRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = const UpdateScheduledSmsState(isLoading: true);
    try {
      final value = await _repository.updateScheduledSms(data);
      if (!value.status) throw value.serverMessage.toString();
      state = const UpdateScheduledSmsState(isLoading: false);
      onSuccess(value.data?.serverMessage ?? 'Schedule updated successfully');
    } catch (e) {
      state = const UpdateScheduledSmsState(isLoading: false);
      onError(e.toString());
    }
  }
}

final updateScheduledSmsNotifier = NotifierProvider.autoDispose<
    UpdateScheduledSmsNotifier, UpdateScheduledSmsState>(
  UpdateScheduledSmsNotifier.new,
);
