import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/senderid/views/delete_sender_id_request.dart';

// TODO: replace AsyncValue<void> / this.state.isLoading pattern with
// whatever your actual base notifier / state class is (mirroring
// setTransactionPinNotifier's shape). This stub assumes an
// AsyncNotifier<void>-style state so `.state.isLoading` in the view works.

class DeleteSenderIdNotifier extends StateNotifier<AsyncValue<void>> {
  DeleteSenderIdNotifier() : super(const AsyncValue.data(null));

  Future<void> deleteSenderId({
    required DeleteSenderIdRequest data,
    required void Function(String message) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = const AsyncValue.loading();
    try {
      // TODO: swap for your actual API client call, e.g.:
      // await ref.read(apiClientProvider).delete('pmcsms.php', data: data.toJson());
      //
      // The endpoint returns no response body on success (confirmed via
      // Postman spec), so success here just means the HTTP call didn't throw.
      state = const AsyncValue.data(null);
      onSuccess('Sender ID deleted successfully');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      onError(e.toString());
    }
  }
}

final deleteSenderIdNotifier =
    StateNotifierProvider<DeleteSenderIdNotifier, AsyncValue<void>>(
  (ref) => DeleteSenderIdNotifier(),
);
