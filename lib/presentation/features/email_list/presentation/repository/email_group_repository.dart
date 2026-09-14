// lib/presentation/features/email_list/data/repository/email_group_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/add_email_group_request.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/delete_email_group_request.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/edit_email_group_request.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_group_mutation_response.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/get_email_groups_response.dart';

class EmailGroupRepository {
  EmailGroupRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<GetEmailGroupsResponse>> getEmailGroups() async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        queryParameters: {
          'process': 'pm_groups',
          'action': 'my_email_groups',
        },
      );
      final parsed = GetEmailGroupsResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<GetEmailGroupsResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<EmailGroupMutationResponse>> addEmailGroup(
      AddEmailGroupRequest request) async {
    try {
      final response = await _dio.post('/pmcsms.php', data: request.toJson());
      final parsed = EmailGroupMutationResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<EmailGroupMutationResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<EmailGroupMutationResponse>> editEmailGroup(
      EditEmailGroupRequest request) async {
    try {
      final response = await _dio.post('/pmcsms.php', data: request.toJson());
      final parsed = EmailGroupMutationResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<EmailGroupMutationResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<EmailGroupMutationResponse>> deleteEmailGroup(
      DeleteEmailGroupRequest request) async {
    try {
      final response = await _dio.post('/pmcsms.php', data: request.toJson());
      final parsed = EmailGroupMutationResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<EmailGroupMutationResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final emailGroupRepositoryProvider = Provider<EmailGroupRepository>(
  (ref) => EmailGroupRepository(ref.read(appDioProvider)),
);
