import 'dart:async';
import 'package:dio/dio.dart';
import 'package:pmcsms/core/config/exception/logger.dart';
import 'package:pmcsms/data/data/local_data_source/local_storage_impl.dart';

class HeaderInterCeptor extends Interceptor {
  HeaderInterCeptor({
    required this.dio,
    required this.secureStorage,
    required this.onTokenExpired,
  });

  final Dio dio;
  final SecureStorage secureStorage;
  final void Function() onTokenExpired;

  @override
  FutureOr<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final apiKey = await secureStorage.getUserApiKey();
      final token = await secureStorage.getUserToken();

      // Explicitly check for actual data and avoid string-coerced "null"
      final cleanToken = (token != null && token.toString() != 'null')
          ? token.toString().trim()
          : '';
      final cleanApiKey = (apiKey != null && apiKey.toString() != 'null')
          ? apiKey.toString().trim()
          : '';

      debugLog('[ACCESS TOKEN] $cleanApiKey');
      debugLog('[TOKEN] $cleanToken');
      debugLog('[API_KEY from storage] $cleanApiKey');
      debugLog('[TOKEN from storage] $cleanToken');
      debugLog('[RESOLVED HEADER] ${options.headers['Authorization']}');

      if (cleanToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $cleanToken';
      } else if (cleanApiKey.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $cleanApiKey';
      } else {
        // Remove the header completely if no credentials exist yet to avoid sending malformed strings
        options.headers.remove('Authorization');
        debugLog(
            '⚠️ Warning: No valid Authorization credentials found in storage.');
      }
    } catch (e) {
      debugLog('Error extracting headers inside interceptor: $e');
    }

    debugLog('[URL] ${options.uri}');
    debugLog('[BODY] ${options.data}');
    debugLog('[METHOD] ${options.method}');
    debugLog('[QUERIES] ${options.queryParameters}');
    debugLog('[HEADERS] ${options.headers}');

    handler.next(options);
    return options;
  }

  @override
  FutureOr<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    debugLog('[ERROR] ${err.requestOptions.uri}');
    debugLog('[ERROR] ${err.response}');

    final statusCode = err.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      onTokenExpired();
    }

    handler.next(err);
    return err;
  }

  @override
  FutureOr<dynamic> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    debugLog(
        '[RESPONSE FROM ${response.requestOptions.path}]: ${response.data}');
    handler.next(response);
    return response;
  }
}
