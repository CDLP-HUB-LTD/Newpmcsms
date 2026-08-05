// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/buy_unit/data/model/buy_unit_request.dart';
// import 'package:pmcsms/presentation/features/buy_unit/data/model/buy_unit_response.dart';

// class BuyUnitRepository {
//   BuyUnitRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<BuyUnitResponse>> buyUnit(BuyUnitRequest request) async {
//     try {
//       final response = await _restClient.buyUnit(request);
//       return BaseResponse<BuyUnitResponse>(
//           status: response.status!, data: response);
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final buyUnitRepositoryProvider = Provider<BuyUnitRepository>(
//   (ref) => BuyUnitRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your new dio provider file
import 'package:pmcsms/presentation/features/buy_unit/data/model/buy_unit_request.dart';
import 'package:pmcsms/presentation/features/buy_unit/data/model/buy_unit_response.dart';

class BuyUnitRepository {
  BuyUnitRepository(this._dio);
  final Dio _dio; // Swap RestClient for clean Dio

  Future<BaseResponse<BuyUnitResponse>> buyUnit(BuyUnitRequest request) async {
    try {
      // Make a direct POST request to the endpoint using your request model's toJson()
      final response = await _dio.post(
        '/pmcsms.php',
        data: request.toJson(),
      );

      // Parse the raw JSON map into your response model
      final buyUnitResponse =
          BuyUnitResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<BuyUnitResponse>(
        status: buyUnitResponse.status!,
        data: buyUnitResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final buyUnitRepositoryProvider = Provider<BuyUnitRepository>(
  (ref) => BuyUnitRepository(
    ref.read(appDioProvider), // Inject the global Dio instance here
  ),
);
