// lib/presentation/features/phonebook/presentation/notifier/edit_group_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_state/base_state.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_group_request.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_group_response.dart';
import 'package:pmcsms/presentation/features/phonebook/data/repository/edit_group_repository.dart';

class EditGroupNotifier
    extends AutoDisposeNotifier<BaseState<EditGroupResponse>> {
  EditGroupNotifier();

  late EditGroupRepository _editGroupRepository;

  @override
  BaseState<EditGroupResponse> build() {
    _editGroupRepository = ref.read(editGroupRepositoryProvider);

    return BaseState<EditGroupResponse>.initial();
  }

  Future<void> editGroup({
    required EditGroupRequest data,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    state = state.copyWith(state: LoadState.loading);

    try {
      final value = await _editGroupRepository.editGroup(data);

      if (!value.status) throw value.serverMessage.toString();

      state = state.copyWith(state: LoadState.success, data: value.data);
      onSuccess(value.data!.serverMessage!);
    } catch (e) {
      onError(e.toString());
      state = state.copyWith(state: LoadState.idle);
    }
  }
}

final editGroupNotifier = NotifierProvider.autoDispose<EditGroupNotifier,
    BaseState<EditGroupResponse>>(
  EditGroupNotifier.new,
);
