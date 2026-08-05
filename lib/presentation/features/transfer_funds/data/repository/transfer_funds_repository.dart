// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/transfer_funds/data/model/transfer_funds_request.dart';
// import 'package:pmcsms/presentation/features/transfer_funds/data/model/transfer_funds_response.dart';

// class TransferFundsRepository {
//   TransferFundsRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<TransferFundsReponse>> transferFunds(
//       TransferFundsRequest request) async {
//     try {
//       final response = await _restClient.transferFunds(request);
//       return BaseResponse<TransferFundsReponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final transferFundsRepositoryProvider = Provider<TransferFundsRepository>(
//   (ref) => TransferFundsRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/transfer_funds/data/model/transfer_funds_request.dart';
import 'package:pmcsms/presentation/features/transfer_funds/data/model/transfer_funds_response.dart';

class TransferFundsRepository {
  TransferFundsRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<TransferFundsReponse>> transferFunds(
      TransferFundsRequest request) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: request.toJson(),
      );

      final transferResponse =
          TransferFundsReponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<TransferFundsReponse>(
        status: transferResponse.status!,
        data: transferResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final transferFundsRepositoryProvider = Provider<TransferFundsRepository>(
  (ref) => TransferFundsRepository(
    ref.read(appDioProvider),
  ),
);
