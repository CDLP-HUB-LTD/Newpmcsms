// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/add_draft_request.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/add_draft_response.dart';

// class AddDraftsRepository {
//   AddDraftsRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<AddDraftsResponse>> addDrafts({
//     required AddDraftsRequests addDraftsRequest,
//   }) async {
//     try {
//       final response = await _restClient.addDraft(addDraftsRequest);
//       return BaseResponse(status: response.status!, data: response);
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final addDraftsRepositoryProvider = Provider<AddDraftsRepository>(
//   (ref) => AddDraftsRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your central dio provider file
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/add_draft_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/add_draft_response.dart';

class AddDraftsRepository {
  AddDraftsRepository(this._dio);
  final Dio _dio; // Replaced RestClient with standard Dio

  Future<BaseResponse<AddDraftsResponse>> addDrafts({
    required AddDraftsRequests addDraftsRequest,
  }) async {
    try {
      // Direct POST request using the request model's toJson() method
      final response = await _dio.post(
        '/pmcsms.php',
        data: addDraftsRequest.toJson(),
      );

      // Parse the JSON map response into the AddDraftsResponse model
      final addDraftResponse =
          AddDraftsResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse(
        status: addDraftResponse.status!,
        data: addDraftResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final addDraftsRepositoryProvider = Provider<AddDraftsRepository>(
  (ref) => AddDraftsRepository(
    ref.read(
        appDioProvider), // Swap restClientProvider with your core Dio instance
  ),
);
