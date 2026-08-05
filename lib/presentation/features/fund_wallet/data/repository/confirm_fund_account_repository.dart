// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/fund_wallet/data/model/confirm_payment_request.dart';
// import 'package:pmcsms/presentation/features/fund_wallet/data/model/confirm_payment_response.dart';

// class ConfirmFundAccountOnlineRepository {
//   ConfirmFundAccountOnlineRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<ConfirmPaymentResponse>> confirmFundAccount(
//       ConfirmPaymentRequest confirmFundAccountRequest) async {
//     try {
//       final response =
//           await _restClient.confirmAccountOnline(confirmFundAccountRequest);
//       return BaseResponse<ConfirmPaymentResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final confirmFundAccountOnlineRepositoryProvider =
//     Provider<ConfirmFundAccountOnlineRepository>(
//   (ref) => ConfirmFundAccountOnlineRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your central dio provider file
import 'package:pmcsms/presentation/features/fund_wallet/data/model/confirm_payment_request.dart';
import 'package:pmcsms/presentation/features/fund_wallet/data/model/confirm_payment_response.dart';

class ConfirmFundAccountOnlineRepository {
  ConfirmFundAccountOnlineRepository(this._dio);
  final Dio _dio; // Replaced RestClient with standard Dio

  Future<BaseResponse<ConfirmPaymentResponse>> confirmFundAccount(
      ConfirmPaymentRequest confirmFundAccountRequest) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: confirmFundAccountRequest.toJson(),
      );

      final confirmResponse = ConfirmPaymentResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<ConfirmPaymentResponse>(
        status: confirmResponse.status!,
        data: confirmResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final confirmFundAccountOnlineRepositoryProvider =
    Provider<ConfirmFundAccountOnlineRepository>(
  (ref) => ConfirmFundAccountOnlineRepository(
    ref.read(appDioProvider), // Inject central Dio instance
  ),
);
