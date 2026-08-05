// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/phonebook/data/model/delete_group_request.dart';
// import 'package:pmcsms/presentation/features/phonebook/data/model/delete_group_response.dart';

// class DeleteGroupRepository {
//   DeleteGroupRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<DeleteGroupResponse>> deleteGroup(
//       DeleteGroupRequest request) async {
//     try {
//       final response = await _restClient.deleteGroup(request);
//       return BaseResponse<DeleteGroupResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final deleteGroupRepositoryProvider = Provider<DeleteGroupRepository>(
//   (ref) => DeleteGroupRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/delete_group_request.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/delete_group_response.dart';

class DeleteGroupRepository {
  DeleteGroupRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<DeleteGroupResponse>> deleteGroup(
      DeleteGroupRequest request) async {
    try {
      final response = await _dio.delete(
        '/pmcsms.php',
        data: request.toJson(),
      );

      final deleteResponse =
          DeleteGroupResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<DeleteGroupResponse>(
        status: deleteResponse.status!,
        data: deleteResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final deleteGroupRepositoryProvider = Provider<DeleteGroupRepository>(
  (ref) => DeleteGroupRepository(
    ref.read(appDioProvider),
  ),
);
