// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/phonebook/data/model/get_all_groups_request.dart';
// import 'package:pmcsms/presentation/features/phonebook/data/model/get_all_groups_response.dart';

// class GetAllGroupsRepository {
//   GetAllGroupsRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<GetAllGroupsResponse>> getAllGroups(
//     GetAllGroupsRequest request,
//   ) async {
//     try {
//       final response = await _restClient.getAllGroups(request);
//       return BaseResponse<GetAllGroupsResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final getAllGroupsRepositoryProvider = Provider<GetAllGroupsRepository>(
//   (ref) => GetAllGroupsRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/get_all_groups_request.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/get_all_groups_response.dart';

class GetAllGroupsRepository {
  GetAllGroupsRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<GetAllGroupsResponse>> getAllGroups(
    GetAllGroupsRequest request,
  ) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        data: request.toJson(),
      );

      final groupsResponse =
          GetAllGroupsResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<GetAllGroupsResponse>(
        status: groupsResponse.status!,
        data: groupsResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final getAllGroupsRepositoryProvider = Provider<GetAllGroupsRepository>(
  (ref) => GetAllGroupsRepository(
    ref.read(appDioProvider),
  ),
);
