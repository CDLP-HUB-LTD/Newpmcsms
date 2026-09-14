// lib/presentation/features/analytics/presentation/notifier/cost_insight_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_state/base_state.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/model/cost_insight_response.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/repository/statistics_repository.dart';

class CostInsightNotifier
    extends AutoDisposeNotifier<BaseState<CostInsightResponse>> {
  CostInsightNotifier();

  late StatisticsRepository _repository;

  @override
  BaseState<CostInsightResponse> build() {
    _repository = ref.read(statisticsRepositoryProvider);
    return BaseState<CostInsightResponse>.initial();
  }

  Future<void> getCostInsight({
    required String serviceType,
    required int year,
  }) async {
    state = state.copyWith(state: LoadState.loading);
    try {
      final value = await _repository.getCostInsight(
        serviceType: serviceType,
        year: year,
      );
      if (!value.status) throw value.serverMessage.toString();
      state = state.copyWith(state: LoadState.idle, data: value.data);
    } catch (e) {
      state = state.copyWith(state: LoadState.idle);
    }
  }
}

final costInsightNotifier = NotifierProvider.autoDispose<CostInsightNotifier,
    BaseState<CostInsightResponse>>(
  CostInsightNotifier.new,
);
