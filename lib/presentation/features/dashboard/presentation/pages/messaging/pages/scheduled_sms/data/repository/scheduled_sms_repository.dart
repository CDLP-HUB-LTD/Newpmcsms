// lib/presentation/features/dashboard/presentation/pages/messaging/data/repository/scheduled_sms_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/delete_scheduled_message_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/schedule_sms_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/update_scheduled_message_request.dart';
import '../model/create_schedule_sms_request.dart';

class ScheduledSmsRepository {
  ScheduledSmsRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<GetScheduledSmsResponse>> getScheduledSms({
    int start = 1,
    int length = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        queryParameters: {
          'process': 'pm_sms',
          'action': 'user_scheduled_messages',
          'start': start,
          'length': length,
        },
      );
      final parsed = GetScheduledSmsResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<GetScheduledSmsResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<ViewScheduledSmsResponse>> viewScheduledSms(
      int scheduleId) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        queryParameters: {
          'process': 'pm_sms',
          'action': 'view_scheduled_message',
          'schedule_id': scheduleId,
        },
      );
      final parsed = ViewScheduledSmsResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<ViewScheduledSmsResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<ScheduledSmsMutationResponse>> createScheduledSms(
      CreateScheduleSmsRequest request) async {
    try {
      final response = await _dio.post('/pmcsms.php', data: request.toJson());
      final parsed = ScheduledSmsMutationResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<ScheduledSmsMutationResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<ScheduledSmsMutationResponse>> updateScheduledSms(
      UpdateScheduledMessageRequest request) async {
    try {
      final response = await _dio.post('/pmcsms.php', data: request.toJson());
      final parsed = ScheduledSmsMutationResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<ScheduledSmsMutationResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<ScheduledSmsMutationResponse>> deleteScheduledSms(
      DeleteScheduledMessageRequest request) async {
    try {
      final response = await _dio.post('/pmcsms.php', data: request.toJson());
      final parsed = ScheduledSmsMutationResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<ScheduledSmsMutationResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final scheduledSmsRepositoryProvider = Provider<ScheduledSmsRepository>(
  (ref) => ScheduledSmsRepository(ref.read(appDioProvider)),
);
