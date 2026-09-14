import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/utils/enums.dart';

import 'package:pmcsms/presentation/features/email_list/presentation/models/email_address_book_response.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/repository/email_list_repository.dart';

class EmailListState {
  final LoadState state;
  final LoadState submitState;
  final List<EmailAddressBookItem> contacts;

  EmailListState({
    required this.state,
    required this.submitState,
    required this.contacts,
  });

  factory EmailListState.initial() => EmailListState(
        state: LoadState.idle,
        submitState: LoadState.idle,
        contacts: [],
      );

  EmailListState copyWith({
    LoadState? state,
    LoadState? submitState,
    List<EmailAddressBookItem>? contacts,
  }) =>
      EmailListState(
        state: state ?? this.state,
        submitState: submitState ?? this.submitState,
        contacts: contacts ?? this.contacts,
      );
}

class EmailListNotifier extends AutoDisposeNotifier<EmailListState> {
  late EmailListRepository _repository;

  @override
  EmailListState build() {
    _repository = ref.read(emailListRepositoryProvider);
    return EmailListState.initial();
  }

  Future<void> fetchContacts({
    int start = 1,
    int length = 50,
    void Function(String error)? onError,
  }) async {
    state = state.copyWith(state: LoadState.loading);
    try {
      final response = await _repository.getContacts(
        start: start,
        length: length,
      );
      if (response.status != true) {
        throw response.serverMessage ?? 'Failed to load contacts';
      }
      final contacts = response.data?.data ?? [];
      state = state.copyWith(state: LoadState.idle, contacts: contacts);
    } catch (e) {
      state = state.copyWith(state: LoadState.idle);
      onError?.call(e.toString());
    }
  }

  Future<bool> addContact({
    required int groupId,
    required String ownerName,
    required String addressBook,
    required void Function(String error) onError,
    void Function(String message)? onSuccess,
  }) async {
    state = state.copyWith(submitState: LoadState.loading);
    try {
      final response = await _repository.addContact(
        groupId: groupId,
        ownerName: ownerName,
        addressBook: addressBook,
      );
      if (response.status != true) {
        throw response.serverMessage ?? 'Failed to add contact';
      }
      state = state.copyWith(submitState: LoadState.idle);
      onSuccess?.call(response.serverMessage ?? 'Contact added');
      await fetchContacts();
      return true;
    } catch (e) {
      state = state.copyWith(submitState: LoadState.idle);
      onError(e.toString());
      return false;
    }
  }

  Future<bool> editContact({
    required int addressBookId,
    required int groupId,
    required String ownerName,
    required String addressBook,
    required void Function(String error) onError,
    void Function(String message)? onSuccess,
  }) async {
    state = state.copyWith(submitState: LoadState.loading);
    try {
      final response = await _repository.editContact(
        addressBookId: addressBookId,
        groupId: groupId,
        ownerName: ownerName,
        addressBook: addressBook,
      );
      if (response.status != true) {
        throw response.serverMessage ?? 'Failed to update contact';
      }
      state = state.copyWith(submitState: LoadState.idle);
      onSuccess?.call(response.serverMessage ?? 'Contact updated');
      await fetchContacts();
      return true;
    } catch (e) {
      state = state.copyWith(submitState: LoadState.idle);
      onError(e.toString());
      return false;
    }
  }

  Future<bool> deleteContact({
    required int addressBookId,
    required void Function(String error) onError,
    void Function(String message)? onSuccess,
  }) async {
    state = state.copyWith(submitState: LoadState.loading);
    try {
      final response = await _repository.deleteContact(
        addressBookId: addressBookId,
      );
      if (response.status != true) {
        throw response.serverMessage ?? 'Failed to delete contact';
      }
      state = state.copyWith(
        submitState: LoadState.idle,
        contacts: state.contacts
            .where((c) => c.addressBookId != addressBookId)
            .toList(),
      );
      onSuccess?.call(response.serverMessage ?? 'Contact deleted');
      return true;
    } catch (e) {
      state = state.copyWith(submitState: LoadState.idle);
      onError(e.toString());
      return false;
    }
  }
}

final emailListNotifier =
    NotifierProvider.autoDispose<EmailListNotifier, EmailListState>(
  EmailListNotifier.new,
);
