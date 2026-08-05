import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/login/data/model/login_request.dart';
import 'package:pmcsms/presentation/features/login/data/model/login_response.dart';
import 'package:pmcsms/presentation/features/sign_up/data/model/sign_up_request.dart';
import 'package:pmcsms/presentation/features/sign_up/data/model/sign_up_response.dart';

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  Future<SignUpResponse> signUp(SignUpRequest request) async {
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return SignUpResponse.fromJson(response.data);
  }

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }
}

// Provide it to your UI/Notifiers
final authRepositoryProvider = Provider((ref) {
  final dio = ref.watch(appDioProvider);
  return AuthRepository(dio);
});
