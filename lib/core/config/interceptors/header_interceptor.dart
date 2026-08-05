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

  final _authRoutes = [
    '/login',
    '/register',
    '/auth/create-pin',
    '/resendtoken',
    '/user/logout',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/auth/verify-signup-otp',
    '/user/change-pin',
    '/user/change-password',
    '/user/delete',
  ];

  final _optionalRoutes = [
    '/user/change-pin',
    '/user/change-password',
    '/auth/recover',
    '/user/logout',
    '/user/refer',
    '/user/delete',
  ];

  @override
  FutureOr<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final apiKey = await secureStorage.getUserApiKey();
      final token = await secureStorage.getUserToken();

      // Clean check to prevent variable getting values like standard null or String "null"
      final cleanApiKey = (apiKey != null && apiKey.toString() != 'null')
          ? apiKey.toString().trim()
          : '';
      final cleanToken = (token != null && token.toString() != 'null')
          ? token.toString().trim()
          : '';

      debugLog('[ACCESS TOKEN] $cleanApiKey');
      debugLog('[TOKEN] $cleanToken');
      debugLog('[API_KEY from storage] $cleanApiKey');
      debugLog('[TOKEN from storage] $cleanToken');
      debugLog('[RESOLVED HEADER] ${options.headers['Authorization']}');

      // Routing logic evaluation
      if (_optionalRoutes.contains(options.path) && cleanToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $cleanToken';
      } else if (cleanApiKey.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $cleanApiKey';
      } else if (cleanToken.isNotEmpty) {
        // Fallback strategy if target endpoint needs some auth but ApiKey isn't loaded yet
        options.headers['Authorization'] = 'Bearer $cleanToken';
      } else {
        // Clean key entry entirely instead of sending un-parsable data
        options.headers.remove('Authorization');
        debugLog(
            '⚠️ Warning: No explicit authorization keys resolved for current request path.');
      }
    } catch (e) {
      debugLog('Error extracting secure storage parameters: $e');
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

    if ((err.response?.statusCode == 401 || err.response?.statusCode == 403) &&
        !_authRoutes.contains(err.requestOptions.path)) {
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
      '[RESPONSE FROM ${response.requestOptions.path}]: ${response.data}',
    );
    handler.next(response);
    return response;
  }
}

Future<void> handleError(
  ErrorInterceptorHandler handler,
  DioException err,
  Dio dio,
) async {
  final opts = Options(
    method: err.requestOptions.method,
    headers: err.requestOptions.headers,
  );
  final cloneReq = await dio.request<Map<String, dynamic>?>(
    err.requestOptions.path,
    options: opts,
    data: err.requestOptions.data,
    queryParameters: err.requestOptions.queryParameters,
  );

  return handler.resolve(cloneReq);
}
