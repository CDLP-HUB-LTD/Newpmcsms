// lib/presentation/features/email/data/repository/email_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/data/data/local_data_source/api_base_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/email/data/send_bulk_email_request.dart';

class EmailRepository {
  final Dio _dio;
  EmailRepository(this._dio);

  Future<ApiBaseResponse> sendBulkEmail(SendBulkEmailRequest request) async {
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return ApiBaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ApiBaseResponse> getSenderIds({String service = 'email'}) async {
    final response = await _dio.post(
      '/pmcsms.php',
      data: GetServiceSenderIdRequest(service: service).toJson(),
    );
    return ApiBaseResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

final emailRepositoryProvider = Provider((ref) {
  final dio = ref.watch(appDioProvider);
  return EmailRepository(dio);
});
