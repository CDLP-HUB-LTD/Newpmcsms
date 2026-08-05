// // import 'package:dio/dio.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:pmcsms/core/config/base_response/base_response.dart';
// // import 'package:pmcsms/core/config/exception/app_exception.dart';
// // import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// // import 'package:pmcsms/presentation/features/login/data/model/login_request.dart';
// // import 'package:pmcsms/presentation/features/login/data/model/login_response.dart';

// // class LoginRepository {
// //   LoginRepository(this._restClient);
// //   final RestClient _restClient;

// //   Future<BaseResponse<LoginResponse>> login(LoginRequest loginRequest) async {
// //     try {
// //       final response = await _restClient.login(loginRequest);
// //       return BaseResponse<LoginResponse>(
// //           status: response.status!, data: response);
// //       // return response;
// //     } on DioException catch (e) {
// //       return AppException.handleError(e);
// //     }
// //   }
// // }

// // final loginRepositoryProvider = Provider<LoginRepository>(
// //   (ref) => LoginRepository(
// //     ref.read(restClientProvider),
// //   ),
// // );

// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/core/network/dio_client.dart';
// import 'package:pmcsms/presentation/features/login/data/model/login_request.dart';
// import 'package:pmcsms/presentation/features/login/data/model/login_response.dart';

// class LoginRepository {
//   LoginRepository(this._dio);
//   final Dio _dio;

//   Future<BaseResponse<LoginResponse>> login(LoginRequest loginRequest) async {
//     try {
//       final response = await _dio.post(
//         '/pmcsms.php',
//         data: loginRequest.toJson(),
//       );

//       // Handle cases where response.data might arrive as a string or null dynamically
//       if (response.data == null) {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           error: 'Empty response received from server.',
//         );
//       }

//       final loginResponse =
//           LoginResponse.fromJson(response.data as Map<String, dynamic>);

//       return BaseResponse<LoginResponse>(
//         status: loginResponse.status ?? false, // Safe fallback for status
//         data: loginResponse,
//       );
//     } on DioException catch (e) {
//       // Cast explicitly to BaseResponse<LoginResponse> to avoid type mismatch exceptions
//       return AppException.handleError(e) as BaseResponse<LoginResponse>;
//     }
//   }
// }

// final loginRepositoryProvider = Provider<LoginRepository>(
//   (ref) {
//     // ⚠️ CRITICAL FIX: Changed ref.read to ref.watch
//     // This ensures that when the user logs out/in and appDioProvider recreates
//     // itself with new header values, the repository automatically gets the fresh Dio instance.
//     final dio = ref.watch(appDioProvider);
//     return LoginRepository(dio);
//   },
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/login/data/model/login_request.dart';
import 'package:pmcsms/presentation/features/login/data/model/login_response.dart';

class LoginRepository {
  LoginRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<LoginResponse>> login(LoginRequest loginRequest) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: loginRequest.toJson(),
      );

      if (response.data == null) {
        return BaseResponse<LoginResponse>(
          status: false,
          serverMessage: 'Empty response received from server.',
          data: null,
        );
      }

      final loginResponse =
          LoginResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<LoginResponse>(
        status: loginResponse.status ?? false,
        serverMessage: loginResponse.serverMessage,
        data: loginResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError<LoginResponse>(e);
    }
  }
}

final loginRepositoryProvider = Provider<LoginRepository>(
  (ref) {
    final dio = ref.watch(appDioProvider);
    return LoginRepository(dio);
  },
);
