// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/forgot_password/data/model/verify_otp_request.dart';
// import 'package:pmcsms/presentation/features/forgot_password/data/model/verify_otp_request_response.dart';

// class VerifyOtpRepository {
//   VerifyOtpRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<VerifyOtpResponse>> verifyOtp(
//       VerifyOtpRequest verifyOtpRequest) async {
//     try {
//       final response = await _restClient.verifyOtp(verifyOtpRequest);
//       return BaseResponse<VerifyOtpResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final verifyOtpRepositoryProvider = Provider<VerifyOtpRepository>(
//   (ref) => VerifyOtpRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your central dio provider file
import 'package:pmcsms/presentation/features/forgot_password/data/model/verify_otp_request.dart';
import 'package:pmcsms/presentation/features/forgot_password/data/model/verify_otp_request_response.dart';

class VerifyOtpRepository {
  VerifyOtpRepository(this._dio);
  final Dio _dio; // Replaced RestClient with standard Dio

  Future<BaseResponse<VerifyOtpResponse>> verifyOtp(
      VerifyOtpRequest verifyOtpRequest) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: verifyOtpRequest.toJson(),
      );

      final verifyOtpResponse =
          VerifyOtpResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<VerifyOtpResponse>(
        status: verifyOtpResponse.status!,
        data: verifyOtpResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final verifyOtpRepositoryProvider = Provider<VerifyOtpRepository>(
  (ref) => VerifyOtpRepository(
    ref.read(appDioProvider), // Inject central Dio instance
  ),
);
