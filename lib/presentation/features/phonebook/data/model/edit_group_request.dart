// lib/presentation/features/phonebook/data/model/edit_group_request.dart
class EditGroupRequest {
  final String process;
  final String action;
  final int groupId;
  final String groupName;

  EditGroupRequest({
    this.process = 'pm_groups',
    this.action = 'edit_group',
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
