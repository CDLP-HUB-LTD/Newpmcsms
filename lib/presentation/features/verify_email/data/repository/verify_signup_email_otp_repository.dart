// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/verify_email/data/model/verify_signup_email_otp_request.dart';
// import 'package:pmcsms/presentation/features/verify_email/data/model/verify_signup_email_otp_response.dart';

// class VerifySignupEmailOtpRepository {
//   VerifySignupEmailOtpRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<VerifySignupEmailOtpReponse>> verifySignUpEmailOtp(
//       VerifySignupEmailOtpRequest verifyOtpRequest) async {
//     try {
//       final response = await _restClient.verifySignUpEmailOtp(verifyOtpRequest);
//       return BaseResponse<VerifySignupEmailOtpReponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final verifySignUpEmailOtpRepositoryProvider =
//     Provider<VerifySignupEmailOtpRepository>(
//   (ref) => VerifySignupEmailOtpRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/verify_email/data/model/verify_signup_email_otp_request.dart';
import 'package:pmcsms/presentation/features/verify_email/data/model/verify_signup_email_otp_response.dart';

class VerifySignupEmailOtpRepository {
  VerifySignupEmailOtpRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<VerifySignupEmailOtpReponse>> verifySignUpEmailOtp(
      VerifySignupEmailOtpRequest verifyOtpRequest) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: verifyOtpRequest.toJson(),
      );

      final verifyResponse = VerifySignupEmailOtpReponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<VerifySignupEmailOtpReponse>(
        status: verifyResponse.status!,
        data: verifyResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final verifySignUpEmailOtpRepositoryProvider =
    Provider<VerifySignupEmailOtpRepository>(
  (ref) => VerifySignupEmailOtpRepository(
    ref.read(appDioProvider),
  ),
);
