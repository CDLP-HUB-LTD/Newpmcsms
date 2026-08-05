// lib/presentation/features/kyc/presentation/notifier/kyc_status_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/kyc/data/kyc_request.dart';

import 'package:pmcsms/presentation/features/kyc/data/source/kyc_api_service.dart';

final kycStatusNotifierProvider =
    StateNotifierProvider<KycStatusNotifier, AsyncValue<KycStatusResponse?>>(
        (ref) {
  final apiService = ref.watch(kycApiServiceProvider);
  return KycStatusNotifier(apiService);
});

class KycStatusNotifier extends StateNotifier<AsyncValue<KycStatusResponse?>> {
  final KycApiService _apiService;

  KycStatusNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> getKycStatus({
    required Function(String error) onError,
    required Function(KycStatusResponse response) onSuccess,
  }) async {
    state = const AsyncValue.loading();
    try {
      final request = KycStatusRequest();
      final response = await _apiService.fetchKycStatus(request);

      state = AsyncValue.data(response);
      onSuccess(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      onError(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
