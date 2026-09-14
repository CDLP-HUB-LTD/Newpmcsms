// lib/presentation/features/senderid/views/create_sender_id_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/repository/sender_id_repository.dart';
import 'package:pmcsms/presentation/features/senderid/views/create_sender_id_request.dart';

class CreateSenderIdState {
  final bool isLoading;
  const CreateSenderIdState({this.isLoading = false});
}

class CreateSenderIdNotifier extends AutoDisposeNotifier<CreateSenderIdState> {
  CreateSenderIdNotifier();

  late SenderIdRepository _repository;

  @override
  CreateSenderIdState build() {
    _repository = ref.read(senderIdRepositoryProvider);
    return const CreateSenderIdState();
  }

  Future<void> createSenderId({
    required CreateSenderIdRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = const CreateSenderIdState(isLoading: true);

    try {
      final value = await _repository.createSenderId(data);

      if (!value.status) throw value.serverMessage.toString();

      state = const CreateSenderIdState(isLoading: false);
      onSuccess(value.data?.serverMessage ?? 'Sender ID created successfully');
    } catch (e) {
      state = const CreateSenderIdState(isLoading: false);
      onError(e.toString());
    }
  }
}

final createSenderIdNotifier =
    NotifierProvider.autoDispose<CreateSenderIdNotifier, CreateSenderIdState>(
  CreateSenderIdNotifier.new,
);
