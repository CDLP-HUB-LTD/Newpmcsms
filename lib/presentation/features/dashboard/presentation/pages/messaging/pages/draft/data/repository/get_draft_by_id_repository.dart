// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_draft_by_id_request.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_draft_by_id_response.dart';

// class GetDraftByIdRepository {
//   GetDraftByIdRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<GetDraftByIdResponse>> getDraftById({
//     required GetDraftByIdRequest getDraftByIdRequest,
//   }) async {
//     try {
//       final response = await _restClient.getDraftById(getDraftByIdRequest);
//       return BaseResponse(status: response.status!, data: response);
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final getDraftByIdRepositoryProvider = Provider<GetDraftByIdRepository>(
//   (ref) => GetDraftByIdRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_draft_by_id_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/draft/data/models/get_draft_by_id_response.dart';

class GetDraftByIdRepository {
  GetDraftByIdRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<GetDraftByIdResponse>> getDraftById({
    required GetDraftByIdRequest getDraftByIdRequest,
  }) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        data: getDraftByIdRequest.toJson(),
      );

      final draftByIdResponse =
          GetDraftByIdResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse(
        status: draftByIdResponse.status!,
        data: draftByIdResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final getDraftByIdRepositoryProvider = Provider<GetDraftByIdRepository>(
  (ref) => GetDraftByIdRepository(
    ref.read(appDioProvider),
  ),
);
