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
