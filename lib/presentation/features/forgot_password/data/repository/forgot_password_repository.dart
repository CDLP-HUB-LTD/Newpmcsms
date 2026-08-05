// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/forgot_password/data/model/forgot_password_request.dart';
// import 'package:pmcsms/presentation/features/forgot_password/data/model/forgot_password_response.dart';

// class ForgotPasswordRepository {
//   ForgotPasswordRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<ForgotPasswordResponse>> forgotPassword(
//       ForgotPasswordRequest forgotPasswordRequest) async {
//     try {
//       final response = await _restClient.forgotPassword(forgotPasswordRequest);
//       return BaseResponse<ForgotPasswordResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final forgotPasswordRepositoryProvider = Provider<ForgotPasswordRepository>(
//   (ref) => ForgotPasswordRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your central dio provider file
import 'package:pmcsms/presentation/features/forgot_password/data/model/forgot_password_request.dart';
import 'package:pmcsms/presentation/features/forgot_password/data/model/forgot_password_response.dart';

class ForgotPasswordRepository {
  ForgotPasswordRepository(this._dio);
  final Dio _dio; // Replaced RestClient with standard Dio

  Future<BaseResponse<ForgotPasswordResponse>> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: forgotPasswordRequest.toJson(),
      );

      final forgotPasswordResponse = ForgotPasswordResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<ForgotPasswordResponse>(
        status: forgotPasswordResponse.status!,
        data: forgotPasswordResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final forgotPasswordRepositoryProvider = Provider<ForgotPasswordRepository>(
  (ref) => ForgotPasswordRepository(
    ref.read(appDioProvider), // Inject central Dio instance
  ),
);
