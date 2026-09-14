// lib/presentation/features/analytics/presentation/notifier/message_insight_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_state/base_state.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/model/message_insight_response.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/repository/statistics_repository.dart';

class MessageInsightNotifier
    extends AutoDisposeNotifier<BaseState<MessageInsightResponse>> {
  MessageInsightNotifier();

  late StatisticsRepository _repository;

  @override
  BaseState<MessageInsightResponse> build() {
    _repository = ref.read(statisticsRepositoryProvider);
    return BaseState<MessageInsightResponse>.initial();
  }

  Future<void> getMessageInsight(String duration) async {
    state = state.copyWith(state: LoadState.loading);
    try {
      final value = await _repository.getMessageInsight(duration);
      if (!value.status) throw value.serverMessage.toString();
      state = state.copyWith(state: LoadState.idle, data: value.data);
    } catch (e) {
      state = state.copyWith(state: LoadState.idle);
    }
  }
}

final messageInsightNotifier = NotifierProvider.autoDispose<
    MessageInsightNotifier, BaseState<MessageInsightResponse>>(
  MessageInsightNotifier.new,
);
