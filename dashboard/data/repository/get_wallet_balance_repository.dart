import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/dashboard/data/model/get_balance_request.dart';
import 'package:pmcsms/presentation/features/dashboard/data/model/get_balance_response.dart';

class GetBalanceRepository {
  GetBalanceRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<GetBalanceResponse>> getWalletBalance({
    required GetBalanceRequest getBalanceRequest,
  }) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        queryParameters: getBalanceRequest.toJson(),
      );
      final balanceResponse =
          GetBalanceResponse.fromJson(response.data as Map<String, dynamic>);
      return BaseResponse(
        status: balanceResponse.status!,
        data: balanceResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final getWalletBalanceRepositoryProvider = Provider<GetBalanceRepository>(
  (ref) => GetBalanceRepository(
    ref.read(appDioProvider),
  ),
);
