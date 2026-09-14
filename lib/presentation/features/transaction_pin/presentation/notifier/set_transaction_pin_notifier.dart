import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/transaction_pin/data/repository/set_transaction_pin_repository.dart';
import 'package:pmcsms/presentation/features/transaction_pin/data/set_transaction_pin_request.dart';

class TransactionPinState {
  final bool isLoading;
  const TransactionPinState({this.isLoading = false});

  TransactionPinState copyWith({bool? isLoading}) =>
      TransactionPinState(isLoading: isLoading ?? this.isLoading);
}

class TransactionPinController extends StateNotifier<TransactionPinState> {
  final TransactionPinRepository _repository;

  TransactionPinController(this._repository)
      : super(const TransactionPinState());

  Future<void> submit({
    required TransactionPinRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.submit(data);
      state = state.copyWith(isLoading: false);

      if (response.status) {
        onSuccess(response.serverMessage.isNotEmpty
            ? response.serverMessage
            : 'Transaction pin updated');
      } else {
        onError(response.serverMessage.isNotEmpty
            ? response.serverMessage
            : 'Unable to update transaction pin');
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
      onError('Something went wrong. Please try again.');
    }
  }
}

/// Shared between SetTransactionPin and ChangePaymentPinView — each screen
/// just builds a different TransactionPinRequest (.set vs .update).
final transactionPinNotifier = StateNotifierProvider.autoDispose<
    TransactionPinController, TransactionPinState>((ref) {
  final repository = ref.watch(transactionPinRepositoryProvider);
  return TransactionPinController(repository);
});
