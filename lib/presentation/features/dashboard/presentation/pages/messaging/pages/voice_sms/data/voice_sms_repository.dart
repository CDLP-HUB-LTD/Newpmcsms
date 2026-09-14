import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/voice_sms/data/voice_sms_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/voice_sms/data/voice_sms_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/voice_sms/data/voice_sms_senderid_request.dart';

class VoiceSmsRepository {
  VoiceSmsRepository(this._dio);

  final Dio _dio;

  Future<PmcsmsResponse> sendVoiceSms(SendVoiceSmsRequest request) async {
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return PmcsmsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PmcsmsResponse> getServiceSenderId(
    GetServiceSenderIdRequest request,
  ) async {
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return PmcsmsResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

// Adjust the import path above to wherever `appDioProvider` actually lives
// in your project (it's shown here coming from core/network/dio_client.dart
// per the snippet you shared).
final voiceSmsRepositoryProvider = Provider<VoiceSmsRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return VoiceSmsRepository(dio);
});
