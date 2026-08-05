// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/transaction_pin/data/set_transaction_pin_request.dart';
// import 'package:pmcsms/presentation/features/transaction_pin/data/set_transaction_pin_response.dart';

// class SetTransactionPinRepository {
//   SetTransactionPinRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<SetTransactionPinResponse>> setTransactionPin(
//       SetTransactionPinRequest request) async {
//     try {
//       final response = await _restClient.setTransactionPin(request);
//       return BaseResponse<SetTransactionPinResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final setTransactionPinRepositoryProvider =
//     Provider<SetTransactionPinRepository>(
//   (ref) => SetTransactionPinRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/transaction_pin/data/set_transaction_pin_request.dart';
import 'package:pmcsms/presentation/features/transaction_pin/data/set_transaction_pin_response.dart';

class SetTransactionPinRepository {
  SetTransactionPinRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<SetTransactionPinResponse>> setTransactionPin(
      SetTransactionPinRequest request) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: request.toJson(),
      );

      final pinResponse = SetTransactionPinResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<SetTransactionPinResponse>(
        status: pinResponse.status!,
        data: pinResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final setTransactionPinRepositoryProvider =
    Provider<SetTransactionPinRepository>(
  (ref) => SetTransactionPinRepository(
    ref.read(appDioProvider),
  ),
);
