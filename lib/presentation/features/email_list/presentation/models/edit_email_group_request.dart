// lib/presentation/features/email_list/data/model/edit_email_group_request.dart
class EditEmailGroupRequest {
  final String process;
  final String action;
  final int groupId;
  final String groupName;

  EditEmailGroupRequest({
    this.process = 'pm_groups',
    this.action = 'edit_email_group',
    required this.groupId,
    required this.groupName,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'group_id': groupId,
        'group_name': groupName,
      };
}
