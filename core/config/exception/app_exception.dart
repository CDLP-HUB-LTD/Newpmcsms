import 'package:dio/dio.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/logger.dart';
import 'package:pmcsms/core/utils/strings.dart';

class AppException implements Exception {
  static BaseResponse<T> handleError<T>(
    DioException e, {
    T? data,
    T Function(Map<String, dynamic>)? fromJsonT,
  }) {
    debugLog(e);

    if (e.response != null && DioExceptionType.badResponse == e.type) {
      final statusCode = e.response?.statusCode ?? 0;

      if (statusCode >= 500) {
        return BaseResponse(
          status: false,
          serverMessage: Strings.serverError,
          data: data,
        );
      }

      if (statusCode == 413) {
        return BaseResponse(
          status: false,
          serverMessage: 'File size too large',
          data: data,
        );
      }

      if (e.response?.data is Map<String, dynamic>) {
        final responseData = e.response?.data as Map<String, dynamic>;
        debugLog(responseData);

        return BaseResponse(
          status: false,
          data: data,
          serverMessage: responseData['server_message'] as String?,
          errorData: responseData['error_data'],
        );
      } else if (e.response?.data is String) {
        debugLog(e.response?.data);
        return BaseResponse(
          status: false,
          serverMessage: e.response?.data as String,
        );
      }
    }

    return BaseResponse(
      status: false,
      data: data,
      serverMessage: _mapException(e.type),
    );
  }

  static String _mapException(DioExceptionType? error) {
    if (DioExceptionType.connectionTimeout == error ||
        DioExceptionType.receiveTimeout == error ||
        DioExceptionType.sendTimeout == error) {
      return Strings.timeout;
    } else if (DioExceptionType.connectionError == error) {
      return Strings.connectionError;
    }
    return Strings.genericErrorMessage;
  }
}
