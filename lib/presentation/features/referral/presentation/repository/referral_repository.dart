// lib/presentation/features/referral/data/repository/referral_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/referral/presentation/model/referral_response.dart';

class ReferralRepository {
  ReferralRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<MyReferralsResponse>> getMyReferrals({
    int start = 1,
    int length = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        queryParameters: {
          'process': 'pm_user',
          'action': 'my_referrals',
          'start': start,
          'length': length,
        },
      );
      final parsed =
          MyReferralsResponse.fromJson(response.data as Map<String, dynamic>);
      return BaseResponse<MyReferralsResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final referralRepositoryProvider = Provider<ReferralRepository>(
  (ref) => ReferralRepository(ref.read(appDioProvider)),
);
