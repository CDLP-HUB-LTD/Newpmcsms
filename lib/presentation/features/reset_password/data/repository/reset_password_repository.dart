// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/reset_password/data/model/reset_password_request.dart';
// import 'package:pmcsms/presentation/features/reset_password/data/model/reset_password_response.dart';

// class ResetPasswordRepository {
//   ResetPasswordRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<ResetPasswordResponse>> resetPassword(
//       ResetPasswordRequest resetPasswordRequest) async {
//     try {
//       final response = await _restClient.resetPassword(resetPasswordRequest);
//       return BaseResponse<ResetPasswordResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final resetPasswordRepositoryProvider = Provider<ResetPasswordRepository>(
//   (ref) => ResetPasswordRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your central dio provider file
import 'package:pmcsms/presentation/features/reset_password/data/model/reset_password_request.dart';
import 'package:pmcsms/presentation/features/reset_password/data/model/reset_password_response.dart';

class ResetPasswordRepository {
  ResetPasswordRepository(this._dio);
  final Dio _dio; // Replaced RestClient with standard Dio

  Future<BaseResponse<ResetPasswordResponse>> resetPassword(
      ResetPasswordRequest resetPasswordRequest) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: resetPasswordRequest.toJson(),
      );

      final resetResponse =
          ResetPasswordResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<ResetPasswordResponse>(
        status: resetResponse.status!,
        data: resetResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final resetPasswordRepositoryProvider = Provider<ResetPasswordRepository>(
  (ref) => ResetPasswordRepository(
    ref.read(appDioProvider), // Inject central Dio instance
  ),
);
