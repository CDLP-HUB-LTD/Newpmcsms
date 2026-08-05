// lib/presentation/features/email_list/view/add_to_group_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_list_model.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Screen for choosing which group(s) a contact should belong to.
///
/// Push with the contact, e.g.:
/// ```dart
/// await Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => AddToGroupView(contact: contact)),
/// );
/// ```
class AddToGroupView extends ConsumerStatefulWidget {
  const AddToGroupView({super.key, required this.contact});

  static const String routeName = '/addToGroup';

  final EmailContact contact;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddToGroupViewState();
}

class _AddToGroupViewState extends ConsumerState<AddToGroupView> {
  final _newGroupController = TextEditingController();

  // TODO: replace with ref.watch(groupsNotifier.select((v) => v.groups))
  final List<EmailGroup> _groups = const [
    EmailGroup(id: 'g1', name: 'Marketing', contactCount: 12),
    EmailGroup(id: 'g2', name: 'Suppliers', contactCount: 5),
    EmailGroup(id: 'g3', name: 'VIP Customers', contactCount: 3),
  ];

  late final Set<String> _selectedGroupIds;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedGroupIds = {...widget.contact.groupIds};
  }

  @override
  void dispose() {
    _newGroupController.dispose();
    super.dispose();
  }

  Future<void> _onDone() async {
    setState(() => _isSaving = true);

    // TODO: replace with a real call, e.g.
    // await ref.read(contactsNotifier.notifier).setGroups(
    //       widget.contact.id,
    //       _selectedGroupIds.toList(),
    //     );
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(context, _selectedGroupIds.toList());
  }

  void _showCreateGroupSheet() {
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
              controller: _newGroupController,
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
                  final name = _newGroupController.text.trim();
                  if (name.isEmpty) return;
                  // TODO: call ref.read(groupsNotifier.notifier).create(name)
                  _newGroupController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add ${widget.contact.name} to group'),
      body: PageLoader(
        isLoading: _isSaving,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: _groups.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final group = _groups[index];
                    final isSelected = _selectedGroupIds.contains(group.id);
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isSelected,
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: AppColors.primaryColor,
                      title: Text(group.name, style: context.textTheme.s14w500),
                      subtitle: Text(
                        '${group.contactCount} contacts',
                        style: context.textTheme.s12w400
                            .copyWith(color: Colors.grey[600]),
                      ),
                      onChanged: (checked) => setState(() {
                        if (checked ?? false) {
                          _selectedGroupIds.add(group.id);
                        } else {
                          _selectedGroupIds.remove(group.id);
                        }
                      }),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showCreateGroupSheet,
                        icon: const Icon(Icons.add,
                            color: AppColors.primaryColor),
                        label: Text(
                          'Create new group',
                          style: context.textTheme.s14w500
                              .copyWith(color: AppColors.primaryColor),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const VerticalSpacing(12),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _onDone,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: context.textTheme.s14w600
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
