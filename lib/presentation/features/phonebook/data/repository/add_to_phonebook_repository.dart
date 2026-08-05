// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/config/base_response/base_response.dart';
// import 'package:pmcsms/core/config/exception/app_exception.dart';
// import 'package:pmcsms/data/data/remote_data_source/rest_client.dart';
// import 'package:pmcsms/presentation/features/phonebook/data/model/add_to_phone_book_response.dart';
// import 'package:pmcsms/presentation/features/phonebook/data/model/add_to_phonebook_request.dart';

// class AddToPhonebookRepository {
//   AddToPhonebookRepository(this._restClient);
//   final RestClient _restClient;

//   Future<BaseResponse<AddToPhoneBookResponse>> addToPhonebook(
//       AddToPhoneBookRequest request) async {
//     try {
//       final response = await _restClient.addToPhonebook(request);
//       return BaseResponse<AddToPhoneBookResponse>(
//           status: response.status!, data: response);
//       // return response;
//     } on DioException catch (e) {
//       return AppException.handleError(e);
//     }
//   }
// }

// final addToPhoneBookRepositoryProvider = Provider<AddToPhonebookRepository>(
//   (ref) => AddToPhonebookRepository(
//     ref.read(restClientProvider),
//   ),
// );
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_response/base_response.dart';
import 'package:pmcsms/core/config/exception/app_exception.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/add_to_phone_book_response.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/add_to_phonebook_request.dart';

class AddToPhonebookRepository {
  AddToPhonebookRepository(this._dio);
  final Dio _dio;

  Future<BaseResponse<AddToPhoneBookResponse>> addToPhonebook(
      AddToPhoneBookRequest request) async {
    try {
      final response = await _dio.post(
        '/pmcsms.php',
        data: request.toJson(),
      );

      final phonebookResponse = AddToPhoneBookResponse.fromJson(
          response.data as Map<String, dynamic>);

      return BaseResponse<AddToPhoneBookResponse>(
        status: phonebookResponse.status!,
        data: phonebookResponse,
      );
    } on DioException catch (e) {
      return AppException.handleError(e);
    }
  }
}

final addToPhoneBookRepositoryProvider = Provider<AddToPhonebookRepository>(
  (ref) => AddToPhonebookRepository(
    ref.read(appDioProvider),
  ),
);
