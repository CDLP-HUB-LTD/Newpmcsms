import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';

import 'package:pmcsms/presentation/features/history/presentation/data/model/ms_history_item.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/resend_sms_request.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/resend_sms_response.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/sms_history_request.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/view_sms_request.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/view_sms_response.dart';

class HistoryRepository {
  final Dio _dio;

  HistoryRepository(this._dio);

  Future<SmsHistoryResponse> getServiceHistory(
      SmsHistoryRequest request) async {
    final response =
        await _dio.get('/pmcsms.php', queryParameters: request.toJson());
    return SmsHistoryResponse.fromJson(response.data);
  }

  Future<ViewSmsResponse> viewSms(ViewSmsRequest request) async {
    final response =
        await _dio.get('/pmcsms.php', queryParameters: request.toJson());
    return ViewSmsResponse.fromJson(response.data);
  }

  Future<ResendSmsResponse> resendSms(ResendSmsRequest request) async {
    final response =
        await _dio.get('/pmcsms.php', queryParameters: request.toJson());
    return ResendSmsResponse.fromJson(response.data);
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return HistoryRepository(dio);
});
