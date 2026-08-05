// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_request.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_response.dart';

// class GetAllDraftsRepository {
//   GetAllDraftsRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<GetAllDraftsResponse>> getAllDrafts({
//     required GetAllDraftsRequests getAllDraftsRequest,
//   }) async {
//     try {
//       final response = await _restClient.getAllDrafts(getAllDraftsRequest);
//       return BaseResponse(status: response.status!, data: response);
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final getAllDraftsRepositoryProvider = Provider<GetAllDraftsRepository>(
//   (ref) => GetAllDraftsRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_all_drafts_response.dart';

class GetAllDraftsRepository {
  GetAllDraftsRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<GetAllDraftsResponse>> getAllDrafts({
    required GetAllDraftsRequests getAllDraftsRequest,
  }) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        data: getAllDraftsRequest.toJson(),
      );

      final allDraftsResponse =
          GetAllDraftsResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse(
        status: allDraftsResponse.status!,
        data: allDraftsResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final getAllDraftsRepositoryProvider = Provider<GetAllDraftsRepository>(
  (ref) => GetAllDraftsRepository(
    ref.read(appDioProvider),
  ),
);
