import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/submit_personalised_sms_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/data/model/submit_personalised_sms_response.dart';

class PersonalizedSmsRepository {
  final Dio _dio;

  PersonalizedSmsRepository(this._dio);

  // Using POST + JSON body, matching the autocompose send flow. If this
  // errors with "Invalid Request. You can only use POST request here"
  // despite already being POST, that's the same symptom we hit on the
  // pm_profile endpoints — fix is to override the content type:
  //   options: Options(contentType: Headers.formUrlEncodedContentType)
  Future<SubmitPersonalizedSmsResponse> submit(
      SubmitPersonalizedSmsRequest request) async {
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return SubmitPersonalizedSmsResponse.fromJson(response.data);
  }
}

final personalizedSmsRepositoryProvider =
    Provider<PersonalizedSmsRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return PersonalizedSmsRepository(dio);
});
