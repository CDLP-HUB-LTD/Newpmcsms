// lib/presentation/features/phonebook/data/repository/edit_contact_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_address_book_request.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_address_book_response.dart';

class EditContactRepository {
  EditContactRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<EditAddressBookResponse>> editContact(
      EditAddressBookRequest request) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: request.toJson(),
      );

      final editResponse = EditAddressBookResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<EditAddressBookResponse>(
        status: editResponse.status!,
        data: editResponse,
        serverMessage: editResponse.serverMessage,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final editContactRepositoryProvider = Provider<EditContactRepository>(
  (ref) => EditContactRepository(
    ref.read(appDioProvider),
  ),
);
