// lib/presentation/features/senderid/data/repository/sender_id_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/model/sender_id_mutation_response.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/model/sender_id_response.dart';
import 'package:pmcsms/presentation/features/senderid/views/create_sender_id_request.dart';
import 'package:pmcsms/presentation/features/senderid/views/delete_sender_id_request.dart';

class SenderIdRepository {
  SenderIdRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<GetServiceSenderIdResponse>> getServiceSenderId(
      String service) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        queryParameters: {
          'process': 'pm_messaging',
          'action': 'get_service_sender_id',
          'service': service,
        },
      );
      final parsed = GetServiceSenderIdResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<GetServiceSenderIdResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<SenderIdMutationResponse>> createSenderId(
      CreateSenderIdRequest request) async {
    try {
      final response = await _dio.post('/pmcsms.php', data: request.toJson());
      final parsed = SenderIdMutationResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<SenderIdMutationResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<SenderIdMutationResponse>> deleteSenderId(
      DeleteSenderIdRequest request) async {
    try {
      final response = await _dio.post('/pmcsms.php', data: request.toJson());
      final parsed = SenderIdMutationResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<SenderIdMutationResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final senderIdRepositoryProvider = Provider<SenderIdRepository>(
  (ref) => SenderIdRepository(ref.read(appDioProvider)),
);
