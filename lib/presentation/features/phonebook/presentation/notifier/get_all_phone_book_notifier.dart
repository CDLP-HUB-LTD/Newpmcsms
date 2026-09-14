import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_state/base_state.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/get_all_contacts_response.dart';

import 'package:pmcsms/presentation/features/phonebook/data/repository/get_all_contacts_repository.dart';

class GetPhoneBookNotifier
    extends AutoDisposeNotifier<BaseState<GetAllContactsResponse>> {
  GetPhoneBookNotifier();

  late GetAllContactsRepository _getAllContactsRepository;

  @override
  BaseState<GetAllContactsResponse> build() {
    _getAllContactsRepository = ref.read(getAllContactsRepositoryProvider);

    return BaseState<GetAllContactsResponse>.initial();
  }

  Future<void> getAllContacts({
    int start = 1,
    int length = 50,
  }) async {
    state = state.copyWith(state: LoadState.loading);

    try {
      final value = await _getAllContactsRepository.getAllContacts(
        start: start,
        length: length,
      );

      if (!value.status) throw value.serverMessage.toString();

      state = state.copyWith(state: LoadState.idle, data: value.data);
      //  onSuccess(value.data!.serverMessage!);
    } catch (e) {
      // onError(e.toString());
      state = state.copyWith(state: LoadState.idle);
    }
  }
}

final getAllContactsNotifier = NotifierProvider.autoDispose<
    GetPhoneBookNotifier, BaseState<GetAllContactsResponse>>(
  GetPhoneBookNotifier.new,
);
