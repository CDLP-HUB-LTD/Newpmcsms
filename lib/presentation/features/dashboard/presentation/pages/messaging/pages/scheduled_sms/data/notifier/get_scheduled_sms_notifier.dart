// lib/presentation/features/dashboard/presentation/pages/messaging/presentation/notifier/get_scheduled_sms_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_state/base_state.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/schedule_sms_response.dart';
import '../../data/repository/scheduled_sms_repository.dart';

class GetScheduledSmsNotifier
    extends AutoDisposeNotifier<BaseState<GetScheduledSmsResponse>> {
  GetScheduledSmsNotifier();

  late ScheduledSmsRepository _repository;

  @override
  BaseState<GetScheduledSmsResponse> build() {
    _repository = ref.read(scheduledSmsRepositoryProvider);
    return BaseState<GetScheduledSmsResponse>.initial();
  }

  Future<void> getScheduledSms({int start = 1, int length = 20}) async {
    state = state.copyWith(state: LoadState.loading);
    try {
      final value =
          await _repository.getScheduledSms(start: start, length: length);
      if (!value.status) throw value.serverMessage.toString();
      state = state.copyWith(state: LoadState.idle, data: value.data);
    } catch (e) {
      state = state.copyWith(state: LoadState.idle);
    }
  }
}

final getScheduledSmsNotifier = NotifierProvider.autoDispose<
    GetScheduledSmsNotifier, BaseState<GetScheduledSmsResponse>>(
  GetScheduledSmsNotifier.new,
);
