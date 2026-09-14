// lib/presentation/features/dashboard/presentation/pages/messaging/presentation/notifier/create_scheduled_sms_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/model/create_schedule_sms_request.dart';
import '../../data/repository/scheduled_sms_repository.dart';

class CreateScheduledSmsState {
  final bool isLoading;
  const CreateScheduledSmsState({this.isLoading = false});
}

class CreateScheduledSmsNotifier
    extends AutoDisposeNotifier<CreateScheduledSmsState> {
  CreateScheduledSmsNotifier();

  late ScheduledSmsRepository _repository;

  @override
  CreateScheduledSmsState build() {
    _repository = ref.read(scheduledSmsRepositoryProvider);
    return const CreateScheduledSmsState();
  }

  Future<void> createScheduledSms({
    required CreateScheduleSmsRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = const CreateScheduledSmsState(isLoading: true);
    try {
      final value = await _repository.createScheduledSms(data);
      if (!value.status) throw value.serverMessage.toString();
      state = const CreateScheduledSmsState(isLoading: false);
      onSuccess(value.data?.serverMessage ?? 'Message scheduled successfully');
    } catch (e) {
      state = const CreateScheduledSmsState(isLoading: false);
      onError(e.toString());
    }
  }
}

final createScheduledSmsNotifier = NotifierProvider.autoDispose<
    CreateScheduledSmsNotifier, CreateScheduledSmsState>(
  CreateScheduledSmsNotifier.new,
);
