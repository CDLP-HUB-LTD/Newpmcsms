// lib/presentation/features/senderid/presentation/notifier/sender_id_list_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/model/sender_id_response.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/repository/sender_id_repository.dart';

class SenderIdListState {
  final bool isLoading;
  final List<SenderIdListItem> items;
  final String? error;

  const SenderIdListState({
    this.isLoading = false,
    this.items = const [],
    this.error,
  });

  SenderIdListState copyWith({
    bool? isLoading,
    List<SenderIdListItem>? items,
    String? error,
    bool clearError = false,
  }) {
    return SenderIdListState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class SenderIdListNotifier extends AutoDisposeNotifier<SenderIdListState> {
  SenderIdListNotifier();

  late SenderIdRepository _repository;

  @override
  SenderIdListState build() {
    _repository = ref.read(senderIdRepositoryProvider);
    return const SenderIdListState();
  }

  Future<void> getSenderIds({
    required String service,
    required void Function(String error) onError,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final value = await _repository.getServiceSenderId(service);

      if (!value.status) throw value.serverMessage.toString();

      state = state.copyWith(
        isLoading: false,
        items: value.data?.data ?? [],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      onError(e.toString());
    }
  }

  void removeLocally(String senderId, String service) {
    state = state.copyWith(
      items: state.items
          .where((i) => !(i.senderId == senderId && i.service == service))
          .toList(),
    );
  }
}

final senderIdListNotifier =
    NotifierProvider.autoDispose<SenderIdListNotifier, SenderIdListState>(
  SenderIdListNotifier.new,
);
