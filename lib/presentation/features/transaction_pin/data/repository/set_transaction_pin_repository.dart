import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/presentation/features/transaction_pin/data/set_transaction_pin_request.dart';
import 'package:pmcsms/presentation/features/transaction_pin/data/set_transaction_pin_response.dart';

class TransactionPinRepository {
  final Dio _dio;

  TransactionPinRepository(this._dio);

  // Both set_transact_pin and update_transact_pin returned "Invalid
  // Request. You can only use POST request here" when called with GET —
  // same family of issue as pm_profile/change_password. Use POST here.
  Future<TransactionPinResponse> submit(TransactionPinRequest request) async {
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return TransactionPinResponse.fromJson(response.data);
  }
}

final transactionPinRepositoryProvider =
    Provider<TransactionPinRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return TransactionPinRepository(dio);
});
