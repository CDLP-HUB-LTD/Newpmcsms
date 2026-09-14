import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/send_sms_request.dart';

final smsNotifierProvider =
    StateNotifierProvider<SmsNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(appDioProvider);
  return SmsNotifier(dio);
});

class SmsNotifier extends StateNotifier<AsyncValue<void>> {
  SmsNotifier(this._dio) : super(const AsyncValue.data(null));

  final Dio _dio;

  String _absoluteUrl() {
    final base = _dio.options.baseUrl.replaceAll(RegExp(r'/$'), '');
    return '$base/pmcsms.php';
  }

  /// Fetches active SMS gateways and returns the first available gateway ID.
  /// Returns null if none are found or on error.
  Future<int?> fetchActiveGateway() async {
    try {
      final response = await _dio.post(
        _absoluteUrl(),
        queryParameters: {
          "process": "pm_gateways",
          "action": "get_active_sms_gateways",
        },
      );

      final data = response.data;
      if (data == null || data['status'] == false) return null;

      final List gateways = data['data'] ?? [];
      if (gateways.isEmpty) return null;

      final first = gateways.first as Map<String, dynamic>;
      final rawId = first['gateway_id'] ?? first['id'];
      return rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
    } catch (_) {
      return null;
    }
  }
  // /// Fetches active gateways and returns the first available gateway ID.
  // /// Returns null if none are found or on error.
  // Future<int?> fetchSenderIds() async {
  //   try {
  //     final response = await _dio.post(
  //       _absoluteUrl(),
  //       data: {
  //         "process": "pm_messaging",
  //         "action": "get_service_sender_id",
  //         "service": "sms"
  //       },
  //     );

  //     final data = response.data;
  //     if (data == null || data['status'] == false) return null;

  //     final List senderId = data['data'] ?? [];
  //     if (senderId.isEmpty) return null;

  //     return senderId.first['id'] as int?;
  //   } catch (_) {
  //     return null;
  //   }
  // }

  Future<void> sendAutocomposeSms({
    required SendAutocomposeSmsRequest request,
    required void Function() onSuccess,
    required void Function(String errorMessage) onError,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _dio.post(_absoluteUrl(), data: request.toJson());

      if (response.data != null) {
        if (response.data['status'] == false ||
            response.data['text_status'] == 'FAILED') {
          throw Exception(
              response.data['server_message'] ?? 'SMS Delivery Failed');
        }
        state = const AsyncValue.data(null);
        onSuccess();
      } else {
        throw Exception('Empty response received from backend engine');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['server_message'] ??
          'Failed to complete message dispatch';
      state =
          AsyncValue.error(errorMessage, e.stackTrace ?? StackTrace.current);
      onError(errorMessage.toString());
    } catch (e, stack) {
      final fallbackErr = e.toString().replaceAll('Exception: ', '');
      state = AsyncValue.error(fallbackErr, stack);
      onError(fallbackErr);
    }
  }

  Future<void> sendBulkSms({
    required SendSmsRequest request,
    required void Function() onSuccess,
    required void Function(String errorMessage) onError,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _dio.post(_absoluteUrl(), data: request.toJson());

      if (response.data != null) {
        if (response.data['status'] == false ||
            response.data['text_status'] == 'FAILED') {
          throw Exception(
              response.data['server_message'] ?? 'SMS Delivery Failed');
        }
        state = const AsyncValue.data(null);
        onSuccess();
      } else {
        throw Exception('Empty response received from backend engine');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['server_message'] ??
          'Failed to complete message dispatch';
      state =
          AsyncValue.error(errorMessage, e.stackTrace ?? StackTrace.current);
      onError(errorMessage.toString());
    } catch (e, stack) {
      final fallbackErr = e.toString().replaceAll('Exception: ', '');
      state = AsyncValue.error(fallbackErr, stack);
      onError(fallbackErr);
    }
  }
}
