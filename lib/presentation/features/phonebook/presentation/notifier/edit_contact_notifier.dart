// lib/presentation/features/phonebook/presentation/notifier/edit_contact_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_state/base_state.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_address_book_request.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_address_book_response.dart';
import 'package:pmcsms/presentation/features/phonebook/data/repository/edit_contact_repository.dart';

class EditContactNotifier
    extends AutoDisposeNotifier<BaseState<EditAddressBookResponse>> {
  EditContactNotifier();

  late EditContactRepository _editContactRepository;

  @override
  BaseState<EditAddressBookResponse> build() {
    _editContactRepository = ref.read(editContactRepositoryProvider);

    return BaseState<EditAddressBookResponse>.initial();
  }

  Future<void> editContact({
    required EditAddressBookRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = state.copyWith(state: LoadState.loading);

    try {
      final value = await _editContactRepository.editContact(data);

      if (!value.status) throw value.serverMessage.toString();

      state = state.copyWith(state: LoadState.success, data: value.data);
      onSuccess(value.data!.serverMessage!);
    } catch (e) {
      onError(e.toString());
      state = state.copyWith(state: LoadState.idle);
    }
  }
}

final editContactNotifier = NotifierProvider.autoDispose<EditContactNotifier,
    BaseState<EditAddressBookResponse>>(
  EditContactNotifier.new,
);
