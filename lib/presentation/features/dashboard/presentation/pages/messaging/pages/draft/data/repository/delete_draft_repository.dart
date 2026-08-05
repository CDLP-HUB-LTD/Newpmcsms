// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/delete_draft_request.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/delete_draft_response.dart';

// class DeleteDraftRepository {
//   DeleteDraftRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<DeleteDraftResponse>> deleteDraft({
//     required DeleteDraftRequest deleteDraftRequest,
//   }) async {
//     try {
//       final response = await _restClient.deleteDraft(deleteDraftRequest);
//       return BaseResponse(status: response.status!, data: response);
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final deleteDraftRepositoryProvider = Provider<DeleteDraftRepository>(
//   (ref) => DeleteDraftRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart'; // Import your central dio provider file
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/delete_draft_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/delete_draft_response.dart';

class DeleteDraftRepository {
  DeleteDraftRepository(this._dio);
  final Dio _dio; // Replaced RestClient with standard Dio

  Future<BaseResponse<DeleteDraftResponse>> deleteDraft({
    required DeleteDraftRequest deleteDraftRequest,
  }) async {
    try {
      // Direct DELETE request matching your previous configuration
      final response = await _dio.delete(
        '/pmcsms.php',
        data: deleteDraftRequest.toJson(),
      );

      // Parse the Map response into the DeleteDraftResponse model
      final deleteResponse =
          DeleteDraftResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse(
        status: deleteResponse.status!,
        data: deleteResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final deleteDraftRepositoryProvider = Provider<DeleteDraftRepository>(
  (ref) => DeleteDraftRepository(
    ref.read(
        appDioProvider), // Swap restClientProvider with your core Dio instance
  ),
);
