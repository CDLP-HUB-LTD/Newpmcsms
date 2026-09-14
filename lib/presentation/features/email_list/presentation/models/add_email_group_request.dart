// lib/presentation/features/email_list/data/model/add_email_group_request.dart
class AddEmailGroupRequest {
  final String process;
  final String action;
  final String groupName;

  AddEmailGroupRequest({
    this.process = 'pm_groups',
    this.action = 'add_email_group',
    required this.groupName,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'group_name': groupName,
      };
}
