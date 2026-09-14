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

// lib/.../draft/data/repository/get_all_drafts_repository.dart
  // repository
  Future<BaseResponse<GetAllDraftsResponse>> getAllDrafts({
    required String action,
    int start = 1,
    int length = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        queryParameters: {
          'process': 'pm_drafts',
          'action': action,
          'start': start,
          'length': length,
        },
      );
      final parsed =
          GetAllDraftsResponse.fromJson(response.data as Map<String, dynamic>);
      return BaseResponse<GetAllDraftsResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
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
