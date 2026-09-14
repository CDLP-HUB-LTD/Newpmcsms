import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your central dio provider file
import 'package:pmcsms/presentation/features/dashboard/data/model/get_balance_request.dart';
import 'package:pmcsms/presentation/features/dashboard/data/model/get_balance_response.dart';

class GetBalanceRepository {
  GetBalanceRepository(this._dio);
  final Dio _dio; // Swapped RestClient for standard Dio

  Future<BaseResponse<GetBalanceResponse>> getWalletBalance({
    required GetBalanceRequest getBalanceRequest,
  }) async {
    try {
      // Use _dio.get and supply the JSON payload to the data parameter
      final response = await _dio.post(
        '/pmcsms.php',
        queryParameters: getBalanceRequest.toJson(),
      );

      // Parse the Map response into the GetBalanceResponse model
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
    ref.read(appDioProvider), // Watch your central Dio configuration instance
  ),
);
