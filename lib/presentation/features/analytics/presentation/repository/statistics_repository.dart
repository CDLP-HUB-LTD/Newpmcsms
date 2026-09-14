// lib/presentation/features/analytics/data/repository/statistics_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/model/cost_insight_response.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/model/message_insight_response.dart';

class StatisticsRepository {
  StatisticsRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<MessageInsightResponse>> getMessageInsight(
      String duration) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        queryParameters: {
          'process': 'pm_statistics',
          'action': 'message_insight',
          'duration': duration,
        },
      );
      final parsed = MessageInsightResponse.fromJson(
          response.data as Map<String, dynamic>);
      return BaseResponse<MessageInsightResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }

  Future<BaseResponse<CostInsightResponse>> getCostInsight({
    required String serviceType,
    required int year,
  }) async {
    try {
      final response = await _dio.get(
        '/pmcsms.php',
        queryParameters: {
          'process': 'pm_statistics',
          'action': 'cost_insight',
          'service_type': serviceType,
          'year': year,
        },
      );
      final parsed =
          CostInsightResponse.fromJson(response.data as Map<String, dynamic>);
      return BaseResponse<CostInsightResponse>(
        status: parsed.status!,
        data: parsed,
        serverMessage: parsed.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final statisticsRepositoryProvider = Provider<StatisticsRepository>(
  (ref) => StatisticsRepository(ref.read(appDioProvider)),
);
