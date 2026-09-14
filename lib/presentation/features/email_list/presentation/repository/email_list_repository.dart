import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';

import 'package:pmcsms/presentation/features/email_list/presentation/models/email_address_book_request.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_address_book_response.dart';

class EmailListRepository {
  EmailListRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<EmailAddressBookResponse>> getContacts({
    int start = 1,
    int length = 50,
  }) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data:
            GetEmailAddressBooksRequest(start: start, length: length).toJson(),
      );

      if (response.data == null) {
        return BaseResponse<EmailAddressBookResponse>(
          status: false,
          serverMessage: 'Empty response received from server.',
          data: null,
        );
      }

      final parsed = EmailAddressBookResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<EmailAddressBookResponse>(
        status: parsed.status ?? false,
        serverMessage: parsed.serverMessage,
        data: parsed,
      );
    } on DioException catch (e) {
      return AppException.handleError<EmailAddressBookResponse>(e);
    }
  }

  Future<BaseResponse<EmailAddressBookActionResponse>> addContact({
    required int groupId,
    required String ownerName,
    required String addressBook,
  }) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: AddEmailAddressBookRequest(
          groupId: groupId,
          ownerName: ownerName,
          addressBook: addressBook,
        ).toJson(),
      );

      if (response.data == null) {
        return BaseResponse<EmailAddressBookActionResponse>(
          status: false,
          serverMessage: 'Empty response received from server.',
          data: null,
        );
      }

      final parsed = EmailAddressBookActionResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<EmailAddressBookActionResponse>(
        status: parsed.status ?? false,
        serverMessage: parsed.serverMessage,
        data: parsed,
      );
    } on DioException catch (e) {
      return AppException.handleError<EmailAddressBookActionResponse>(e);
    }
  }

  Future<BaseResponse<EmailAddressBookActionResponse>> editContact({
    required int addressBookId,
    required int groupId,
    required String ownerName,
    required String addressBook,
  }) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: EditEmailAddressBookRequest(
          addressBookId: addressBookId,
          groupId: groupId,
          ownerName: ownerName,
          addressBook: addressBook,
        ).toJson(),
      );

      if (response.data == null) {
        return BaseResponse<EmailAddressBookActionResponse>(
          status: false,
          serverMessage: 'Empty response received from server.',
          data: null,
        );
      }

      final parsed = EmailAddressBookActionResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<EmailAddressBookActionResponse>(
        status: parsed.status ?? false,
        serverMessage: parsed.serverMessage,
        data: parsed,
      );
    } on DioException catch (e) {
      return AppException.handleError<EmailAddressBookActionResponse>(e);
    }
  }

  Future<BaseResponse<EmailAddressBookActionResponse>> deleteContact({
    required int addressBookId,
  }) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: DeleteEmailAddressBookRequest(addressBookId: addressBookId)
            .toJson(),
      );

      if (response.data == null) {
        return BaseResponse<EmailAddressBookActionResponse>(
          status: false,
          serverMessage: 'Empty response received from server.',
          data: null,
        );
      }

      final parsed = EmailAddressBookActionResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<EmailAddressBookActionResponse>(
        status: parsed.status ?? false,
        serverMessage: parsed.serverMessage,
        data: parsed,
      );
    } on DioException catch (e) {
      return AppException.handleError<EmailAddressBookActionResponse>(e);
    }
  }
}

final emailListRepositoryProvider = Provider<EmailListRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return EmailListRepository(dio);
});
