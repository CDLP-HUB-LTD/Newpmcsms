// lib/presentation/features/staff/presentation/notifier/staff_impersonation_notifier.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';

final staffImpersonationProvider =
    StateNotifierProvider<StaffImpersonationNotifier, AsyncValue<bool>>((ref) {
  final dio = ref.watch(appDioProvider);
  return StaffImpersonationNotifier(dio);
});

class StaffImpersonationNotifier extends StateNotifier<AsyncValue<bool>> {
  final Dio _dio;
  StaffImpersonationNotifier(this._dio)
      : super(const AsyncValue.data(
            false)); // Returns true if currently impersonating

  String get _endpoint =>
      '${_dio.options.baseUrl.replaceAll(RegExp(r'/$'), '')}/pmcsms.php';

  /// Switch session view onto a specific target customer account string profile
  Future<void> switchToUser(String email,
      {required void Function() onSessionSwapped}) async {
    state = const AsyncValue.loading();
    try {
      final response = await _dio.post(
        _endpoint,
        data: {
          "process": "pm_staff",
          "action": "switch_to_user",
          "target_user": email.trim(),
        },
      );

      if (response.data?['status'] == true) {
        // NOTE: Make sure your HeaderInterceptor intercepts and replaces the active
        // authentication Bearer tokens if your backend includes a new token payload here!
        state = const AsyncValue.data(true);
        onSessionSwapped();
      } else {
        throw Exception(response.data?['server_message'] ??
            'Failed to switch workspace account');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }

  /// Safely exit support mode and restore native staff clearance profiles
  Future<void> exitImpersonation(
      {required void Function() onExitComplete}) async {
    state = const AsyncValue.loading();
    try {
      final response = await _dio.post(
        _endpoint,
        data: {
          "process": "pm_staff",
          "action": "exit_impersonation",
        },
      );

      if (response.data?['status'] == true) {
        state = const AsyncValue.data(false);
        onExitComplete();
      } else {
        throw Exception(response.data?['server_message'] ??
            'Failed to terminate support pipeline session');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }
}
