// lib/presentation/features/email/data/repository/email_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/data/data/local_data_source/api_base_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/email/data/send_bulk_email_request.dart';

class SmsRepository {
  final Dio _dio;
  SmsRepository(this._dio);

  Future<ApiBaseResponse> getSenderIds({String service = 'sms'}) async {
    final response = await _dio.post(
      '/pmcsms.php',
      data: GetServiceSenderIdRequest(service: service).toJson(),
    );
    return ApiBaseResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

final smsRepositoryProvider = Provider((ref) {
  final dio = ref.watch(appDioProvider);
  return SmsRepository(dio);
});
