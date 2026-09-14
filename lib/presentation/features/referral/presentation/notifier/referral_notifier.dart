// lib/presentation/features/referral/presentation/notifier/referral_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_state/base_state.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/referral/presentation/model/referral_response.dart';
import 'package:pmcsms/presentation/features/referral/presentation/repository/referral_repository.dart';

class ReferralNotifier
    extends AutoDisposeNotifier<BaseState<MyReferralsResponse>> {
  ReferralNotifier();

  late ReferralRepository _repository;

  @override
  BaseState<MyReferralsResponse> build() {
    _repository = ref.read(referralRepositoryProvider);
    return BaseState<MyReferralsResponse>.initial();
  }

  Future<void> getMyReferrals({int start = 1, int length = 20}) async {
    state = state.copyWith(state: LoadState.loading);
    try {
      final value =
          await _repository.getMyReferrals(start: start, length: length);
      if (!value.status) throw value.serverMessage.toString();
      state = state.copyWith(state: LoadState.idle, data: value.data);
    } catch (e) {
      state = state.copyWith(state: LoadState.idle);
    }
  }
}

final referralNotifier = NotifierProvider.autoDispose<ReferralNotifier,
    BaseState<MyReferralsResponse>>(
  ReferralNotifier.new,
);
