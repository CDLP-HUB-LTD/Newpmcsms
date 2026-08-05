// lib/presentation/features/kyc/data/source/kyc_api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/kyc/data/kyc_request.dart';
// import 'your_dio_provider_path.dart';

final kycApiServiceProvider = Provider((ref) {
  final dio = ref.watch(appDioProvider);
  return KycApiService(dio);
});

class KycApiService {
  final Dio _dio;
  KycApiService(this._dio);

  Future<KycStatusResponse> fetchKycStatus(KycStatusRequest request) async {
    try {
      final base = _dio.options.baseUrl.replaceAll(RegExp(r'/$'), '');
      final absoluteUrl = '$base/pmcsms.php';

      // ✅ Changed to .get and changed 'data:' to 'queryParameters:'
      final response = await _dio.get(
        absoluteUrl,
        queryParameters: request.toJson(),
      );

      if (response.data != null) {
        if (response.data['status'] == false ||
            response.data['text_status'] == 'FAILED') {
          throw Exception(
              response.data['server_message'] ?? 'Operation failed');
        }
        return KycStatusResponse.fromJson(response.data);
      }
      throw Exception('Empty response received from server');
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['server_message'] ?? 'Failed to update KYC status';
      throw Exception(errorMessage);
    }
  }
}
