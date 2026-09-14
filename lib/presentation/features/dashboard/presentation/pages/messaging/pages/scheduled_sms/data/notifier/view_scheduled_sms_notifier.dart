// lib/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/view_scheduled_sms_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/schedule_sms_response.dart';
import '../../data/repository/scheduled_sms_repository.dart';

class ViewScheduledSmsState {
  final bool isLoading;
  const ViewScheduledSmsState({this.isLoading = false});
}

class ViewScheduledSmsNotifier
    extends AutoDisposeNotifier<ViewScheduledSmsState> {
  ViewScheduledSmsNotifier();

  late ScheduledSmsRepository _repository;

  @override
  ViewScheduledSmsState build() {
    _repository = ref.read(scheduledSmsRepositoryProvider);
    return const ViewScheduledSmsState();
  }

  Future<void> viewScheduledSms({
    required int scheduleId,
    required void Function(String error) onError,
    required void Function(ScheduledSmsItem item) onSuccess,
  }) async {
    state = const ViewScheduledSmsState(isLoading: true);
    try {
      final value = await _repository.viewScheduledSms(scheduleId);
      if (!value.status) throw value.serverMessage.toString();
      final item = value.data?.data;
      state = const ViewScheduledSmsState(isLoading: false);
      if (item == null) {
        onError('Schedule details not found.');
        return;
      }
      onSuccess(item);
    } catch (e) {
      state = const ViewScheduledSmsState(isLoading: false);
      onError(e.toString());
    }
  }
}

final viewScheduledSmsNotifier = NotifierProvider.autoDispose<
    ViewScheduledSmsNotifier, ViewScheduledSmsState>(
  ViewScheduledSmsNotifier.new,
);
