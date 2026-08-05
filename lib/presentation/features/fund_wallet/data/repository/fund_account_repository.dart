// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/fund_wallet/data/model/fund_account_online_request.dart';
// import 'package:pmcsms/presentation/features/fund_wallet/data/model/fund_account_online_response.dart';

// class FundAccountOnlineRepository {
//   FundAccountOnlineRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<FundAccountOnlineResponse>> fundAccountOnline(
//       FundAccountOnlineRequest fundAccountOnlineRequest) async {
//     try {
//       final response =
//           await _restClient.fundAccountOnline(fundAccountOnlineRequest);
//       return BaseResponse<FundAccountOnlineResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final fundAccountOnlineRepositoryProvider =
//     Provider<FundAccountOnlineRepository>(
//   (ref) => FundAccountOnlineRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your central dio provider file
import 'package:pmcsms/presentation/features/fund_wallet/data/model/fund_account_online_request.dart';
import 'package:pmcsms/presentation/features/fund_wallet/data/model/fund_account_online_response.dart';

class FundAccountOnlineRepository {
  FundAccountOnlineRepository(this._dio);
  final Dio _dio; // Replaced RestClient with standard Dio

  Future<BaseResponse<FundAccountOnlineResponse>> fundAccountOnline(
      FundAccountOnlineRequest fundAccountOnlineRequest) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: fundAccountOnlineRequest.toJson(),
      );

      final fundResponse = FundAccountOnlineResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<FundAccountOnlineResponse>(
        status: fundResponse.status!,
        data: fundResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final fundAccountOnlineRepositoryProvider =
    Provider<FundAccountOnlineRepository>(
  (ref) => FundAccountOnlineRepository(
    ref.read(appDioProvider), // Inject central Dio instance
  ),
);
