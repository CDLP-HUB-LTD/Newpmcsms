// lib/presentation/features/senderid/views/delete_sender_id_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/repository/sender_id_repository.dart';
import 'package:pmcsms/presentation/features/senderid/views/delete_sender_id_request.dart';

class DeleteSenderIdState {
  final bool isLoading;
  const DeleteSenderIdState({this.isLoading = false});
}

class DeleteSenderIdNotifier extends AutoDisposeNotifier<DeleteSenderIdState> {
  DeleteSenderIdNotifier();

  late SenderIdRepository _repository;

  @override
  DeleteSenderIdState build() {
    _repository = ref.read(senderIdRepositoryProvider);
    return const DeleteSenderIdState();
  }

  Future<void> deleteSenderId({
    required DeleteSenderIdRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = const DeleteSenderIdState(isLoading: true);

    try {
      final value = await _repository.deleteSenderId(data);

      if (!value.status) throw value.serverMessage.toString();

      state = const DeleteSenderIdState(isLoading: false);
      onSuccess(value.data?.serverMessage ?? 'Sender ID deleted successfully');
    } catch (e) {
      state = const DeleteSenderIdState(isLoading: false);
      onError(e.toString());
    }
  }
}

final deleteSenderIdNotifier =
    NotifierProvider.autoDispose<DeleteSenderIdNotifier, DeleteSenderIdState>(
  DeleteSenderIdNotifier.new,
);
