// lib/presentation/features/phonebook/data/repository/edit_group_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_group_request.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_group_response.dart';

class EditGroupRepository {
  EditGroupRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<EditGroupResponse>> editGroup(
      EditGroupRequest request) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: request.toJson(),
      );

      final editResponse =
          EditGroupResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<EditGroupResponse>(
        status: editResponse.status!,
        data: editResponse,
        serverMessage: editResponse.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final editGroupRepositoryProvider = Provider<EditGroupRepository>(
  (ref) => EditGroupRepository(
    ref.read(appDioProvider),
  ),
);
