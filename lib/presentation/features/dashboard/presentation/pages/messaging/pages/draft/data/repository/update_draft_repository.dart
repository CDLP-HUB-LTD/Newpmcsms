// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/update_draft_request.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/update_draft_response.dart';

// class UpdateDraftRepository {
//   UpdateDraftRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<UpdateDraftResponse>> updateDraft({
//     required UpdateDraftRequest updateDraftRequest,
//   }) async {
//     try {
//       final response = await _restClient.updateDraft(updateDraftRequest);
//       return BaseResponse(status: response.status!, data: response);
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final updateDraftRepositoryProvider = Provider<UpdateDraftRepository>(
//   (ref) => UpdateDraftRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/update_draft_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/update_draft_response.dart';

class UpdateDraftRepository {
  UpdateDraftRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<UpdateDraftResponse>> updateDraft({
    required UpdateDraftRequest updateDraftRequest,
  }) async {
    try {
      final response = await _dio.put(
        '/pmcsms.php',
        data: updateDraftRequest.toJson(),
      );

      final updateResponse =
          UpdateDraftResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse(
        status: updateResponse.status!,
        data: updateResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final updateDraftRepositoryProvider = Provider<UpdateDraftRepository>(
  (ref) => UpdateDraftRepository(
    ref.read(appDioProvider),
  ),
);
