import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/transactions/data/model/wallet_history_request.dart';
import 'package:pmcsms/presentation/features/transactions/data/model/wallet_history_response.dart';

class GetWalletHistoryRepository {
  GetWalletHistoryRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<WalletHistoryResponse>> getWalletHistory(
    WalletHistoryRequest request,
  ) async {
    try {
// ✅ Correct — send as POST with body
      final response = await _dio.post(
        '/pmcsms.php',
        data: {'process': 'pm_wallet', 'action': 'wallet_history'},
      );
      final historyResponse =
          WalletHistoryResponse.fromJson(response.data as Map<String, dynamic>);
      return BaseResponse<WalletHistoryResponse>(
        status: historyResponse.status!,
        data: historyResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final getWalletHistoryRepositoryProvider = Provider<GetWalletHistoryRepository>(
  (ref) => GetWalletHistoryRepository(
    ref.read(appDioProvider),
  ),
);
