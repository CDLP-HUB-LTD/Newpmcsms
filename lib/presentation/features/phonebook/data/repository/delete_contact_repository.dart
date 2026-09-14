import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/delete_contact_request.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/delete_contact_response.dart';

class DeleteContactRepository {
  DeleteContactRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<DeleteContactResponse>> deleteContact(
      DeleteContactRequest request) async {
    try {
      final response = await _dio.delete(
        '/pmcsms.php',
        data: request.toJson(),
      );

      final deleteResponse =
          DeleteContactResponse.fromJson(response.data as Map<String, dynamic>);

      return BaseResponse<DeleteContactResponse>(
        status: deleteResponse.status!,
        data: deleteResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final deleteContactRepositoryProvider = Provider<DeleteContactRepository>(
  (ref) => DeleteContactRepository(
    ref.read(appDioProvider),
  ),
);
