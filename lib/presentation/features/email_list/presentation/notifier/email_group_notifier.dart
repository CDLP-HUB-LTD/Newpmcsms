// lib/presentation/features/email_list/presentation/notifier/email_group_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/config/base_state/base_state.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/add_email_group_request.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/delete_email_group_request.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/edit_email_group_request.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/get_email_groups_response.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/repository/email_group_repository.dart';

class EmailGroupNotifier
    extends AutoDisposeNotifier<BaseState<GetEmailGroupsResponse>> {
  EmailGroupNotifier();

  late EmailGroupRepository _repository;

  @override
  BaseState<GetEmailGroupsResponse> build() {
    _repository = ref.read(emailGroupRepositoryProvider);
    return BaseState<GetEmailGroupsResponse>.initial();
  }

  Future<void> getEmailGroups() async {
    state = state.copyWith(state: LoadState.loading);
    try {
      final value = await _repository.getEmailGroups();
      if (!value.status) throw value.serverMessage.toString();
      state = state.copyWith(state: LoadState.idle, data: value.data);
    } catch (e) {
      state = state.copyWith(state: LoadState.idle);
    }
  }

  Future<void> addEmailGroup({
    required String groupName,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    try {
      final value = await _repository
          .addEmailGroup(AddEmailGroupRequest(groupName: groupName));
      if (!value.status) throw value.serverMessage.toString();
      onSuccess(value.data?.serverMessage ?? 'Group created successfully');
      await getEmailGroups();
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> editEmailGroup({
    required int groupId,
    required String groupName,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    try {
      final value = await _repository.editEmailGroup(
          EditEmailGroupRequest(groupId: groupId, groupName: groupName));
      if (!value.status) throw value.serverMessage.toString();
      onSuccess(value.data?.serverMessage ?? 'Group updated successfully');
      await getEmailGroups();
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> deleteEmailGroup({
    required int groupId,
    required void Function(String error) onError,
    required void Function(String message) onSuccess,
  }) async {
    try {
      final value = await _repository
          .deleteEmailGroup(DeleteEmailGroupRequest(groupId: groupId));
      if (!value.status) throw value.serverMessage.toString();
      onSuccess(value.data?.serverMessage ?? 'Group deleted successfully');
      await getEmailGroups();
    } catch (e) {
      onError(e.toString());
    }
  }
}

final emailGroupNotifier = NotifierProvider.autoDispose<EmailGroupNotifier,
    BaseState<GetEmailGroupsResponse>>(
  EmailGroupNotifier.new,
);
