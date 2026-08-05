// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/verify_email/data/model/resend_otp_request.dart';
// import 'package:pmcsms/presentation/features/verify_email/data/model/resend_otp_response.dart';

// class ResendOtpRepository {
//   ResendOtpRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<ResendOtpResponse>> resendOtp(
//       ResendOtpRequest resendOtpRequest) async {
//     try {
//       final response = await _restClient.resendOtp(resendOtpRequest);
//       return BaseResponse<ResendOtpResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final resendOtpRepositoryProvider = Provider<ResendOtpRepository>(
//   (ref) => ResendOtpRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/verify_email/data/model/resend_otp_request.dart';
import 'package:pmcsms/presentation/features/verify_email/data/model/resend_otp_response.dart';

class ResendOtpRepository {
  ResendOtpRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<ResendOtpResponse>> resendOtp(
      ResendOtpRequest resendOtpRequest) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: resendOtpRequest.toJson(),
      );

      final otpResponse =
          ResendOtpResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<ResendOtpResponse>(
        status: otpResponse.status!,
        data: otpResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final resendOtpRepositoryProvider = Provider<ResendOtpRepository>(
  (ref) => ResendOtpRepository(
    ref.read(appDioProvider),
  ),
);
