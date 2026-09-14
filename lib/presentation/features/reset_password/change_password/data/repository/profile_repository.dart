import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/reset_password/change_password/data/model/change_password_request.dart';
import 'package:pmcsms/presentation/features/reset_password/change_password/data/model/change_password_response.dart';

class ProfileRepository {
  final Dio _dio;

  ProfileRepository(this._dio);

  // Unlike the pm_sms history endpoints (which require GET), this action
  // requires POST — the server returns "Invalid Request. You can only use
  // POST request here" if called with GET. Method requirements aren't
  // uniform across every process/action on this endpoint, so don't assume
  // one verb applies everywhere; check each action's actual error message.
  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest request) async {
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return ChangePasswordResponse.fromJson(response.data);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return ProfileRepository(dio);
});
