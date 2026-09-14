// lib/presentation/features/email_list/data/model/delete_email_group_request.dart
class DeleteEmailGroupRequest {
  final String process;
  final String action;
  final int groupId;

  DeleteEmailGroupRequest({
    this.process = 'pm_groups',
    this.action = 'delete_email_group',
    required this.groupId,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'group_id': groupId,
      };
}
