// lib/presentation/features/email_list/presentation/view/groups_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_list_model.dart';
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
  // TODO: replace with ref.watch(groupsNotifier.select((v) => v.groups))
  final List<EmailGroup> _groups = const [
    EmailGroup(id: 'g1', name: 'Marketing', contactCount: 12),
    EmailGroup(id: 'g2', name: 'Suppliers', contactCount: 5),
    EmailGroup(id: 'g3', name: 'VIP Customers', contactCount: 3),
  ];

  bool _isManageMode = false;
  final Set<int> _selectedIndexes = {};

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
                  // TODO: call ref.read(groupsNotifier.notifier).create(name)
                  Navigator.pop(sheetContext);
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

  void _confirmDeleteSelected() {
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
            onPressed: () {
              // TODO: call ref.read(groupsNotifier.notifier)
              //   .deleteMany(selected group ids)
              setState(() {
                _selectedIndexes.clear();
                _isManageMode = false;
              });
              Navigator.pop(dialogContext);
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
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_groups.length} Groups',
                    style: context.textTheme.s14w600),
                Row(
                  children: [
                    if (_isManageMode && _selectedIndexes.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            size: 20, color: Colors.red),
                        onPressed: _confirmDeleteSelected,
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
              child: _groups.isEmpty
                  ? Center(
                      child: Text(
                        'No groups yet',
                        style: context.textTheme.s14w400
                            .copyWith(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _groups.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final group = _groups[index];
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
                              : () {
                                  // TODO: navigate to a Group Detail screen
                                  // showing the contacts inside this group.
                                },
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryE6E6E6,
                            child: const Icon(Icons.group_outlined,
                                color: AppColors.primary1C1C1C),
                          ),
                          title: Text(group.name,
                              style: context.textTheme.s14w500),
                          subtitle: Text(
                            '${group.contactCount} contacts',
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
