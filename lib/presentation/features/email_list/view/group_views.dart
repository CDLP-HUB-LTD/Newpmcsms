// lib/presentation/features/email_list/presentation/view/groups_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_group.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_list_model.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/notifier/email_group_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Content for the "Groups" tab on the Email List screen.
///
/// Drop this in where `_buildGroupsPlaceholder()` currently is:
/// ```dart
/// _tab == _EmailListTab.contacts
///     ? _buildContactsList()
///     : const GroupsView(),
/// ```
class GroupsView extends ConsumerStatefulWidget {
  const GroupsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupsViewState();
}

class _GroupsViewState extends ConsumerState<GroupsView> {
  bool _isManageMode = false;
  final Set<int> _selectedIndexes = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(emailGroupNotifier.notifier).getEmailGroups();
    });
    super.initState();
  }

  void _showCreateGroupSheet() {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New group', style: context.textTheme.s16w600),
            const VerticalSpacing(12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Group name',
                filled: true,
                fillColor: AppColors.primaryF5F7F9,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const VerticalSpacing(16),
            SizedBox(
              height: 44,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isEmpty) return;
                  ref.read(emailGroupNotifier.notifier).addEmailGroup(
                        groupName: name,
                        onError: (error) {
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(error)));
                        },
                        onSuccess: (message) {
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(message)));
                        },
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Create group',
                  style:
                      context.textTheme.s14w600.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteSelected(List<EmailGroupData> groups) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Delete group(s)?', style: context.textTheme.s16w600),
        content: Text(
          'This will remove ${_selectedIndexes.length} group(s). '
          'Contacts inside them will not be deleted.',
          style: context.textTheme.s14w400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel',
                style: context.textTheme.s14w500
                    .copyWith(color: Colors.grey[700])),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final ids = _selectedIndexes
                  .map((i) => groups[i].groupId)
                  .whereType<int>()
                  .toList();
              for (final id in ids) {
                await ref.read(emailGroupNotifier.notifier).deleteEmailGroup(
                      groupId: id,
                      onError: (error) => ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(error))),
                      onSuccess: (_) {},
                    );
              }
              setState(() {
                _selectedIndexes.clear();
                _isManageMode = false;
              });
            },
            child: Text('Delete',
                style: context.textTheme.s14w600.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(
        emailGroupNotifier.select((v) => v.data?.data ?? <EmailGroupData>[]));

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${groups.length} Groups',
                    style: context.textTheme.s14w600),
                Row(
                  children: [
                    if (_isManageMode && _selectedIndexes.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            size: 20, color: Colors.red),
                        onPressed: () => _confirmDeleteSelected(groups),
                      ),
                    IconButton(
                      icon: Icon(
                        _isManageMode
                            ? Icons.remove_circle
                            : Icons.remove_circle_outline,
                        size: 20,
                      ),
                      onPressed: () => setState(() {
                        _isManageMode = !_isManageMode;
                        if (!_isManageMode) _selectedIndexes.clear();
                      }),
                    ),
                  ],
                ),
              ],
            ),
            const VerticalSpacing(8),
            Expanded(
              child: groups.isEmpty
                  ? Center(
                      child: Text(
                        'No groups yet',
                        style: context.textTheme.s14w400
                            .copyWith(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.separated(
                      itemCount: groups.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final group = groups[index];
                        final isSelected = _selectedIndexes.contains(index);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: _isManageMode
                              ? () => setState(() {
                                    if (isSelected) {
                                      _selectedIndexes.remove(index);
                                    } else {
                                      _selectedIndexes.add(index);
                                    }
                                  })
                              : null,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryE6E6E6,
                            child: const Icon(Icons.group_outlined,
                                color: AppColors.primary1C1C1C),
                          ),
                          title: Text(group.groupName ?? '',
                              style: context.textTheme.s14w500),
                          subtitle: Text(
                            '${group.totalAddressBooks ?? 0} contacts',
                            style: context.textTheme.s12w400,
                          ),
                          trailing: _isManageMode
                              ? Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: AppColors.primaryColor,
                                )
                              : const Icon(Icons.chevron_right,
                                  color: Colors.grey),
                        );
                      },
                    ),
            ),
          ],
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            heroTag: 'groups_fab',
            backgroundColor: AppColors.primaryColor,
            shape: const CircleBorder(),
            elevation: 0,
            onPressed: _showCreateGroupSheet,
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
