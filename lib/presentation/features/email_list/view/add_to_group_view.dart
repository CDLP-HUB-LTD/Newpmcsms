// lib/presentation/features/email_list/view/add_to_group_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_address_book_response.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_group.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/notifier/email_group_notifier.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/notifier/email_list_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Screen for choosing which single group a contact belongs to.
///
/// The email address-book API only accepts one `group_id` per contact
/// (add_email_address_book / edit_email_address_book both take a single
/// group_id), so this is a single-select — not a multi-select — picker.
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

  final EmailAddressBookItem contact;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddToGroupViewState();
}

class _AddToGroupViewState extends ConsumerState<AddToGroupView> {
  final _newGroupController = TextEditingController();

  int? _selectedGroupId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.contact.groupId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(emailGroupNotifier.notifier).getEmailGroups();
    });
  }

  @override
  void dispose() {
    _newGroupController.dispose();
    super.dispose();
  }

  Future<void> _onDone() async {
    final groupId = _selectedGroupId;
    if (groupId == null) {
      Navigator.pop(context);
      return;
    }
    final addressBookId = widget.contact.addressBookId;
    if (addressBookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Missing contact ID — cannot update group. Please refresh the list and try again.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await ref.read(emailListNotifier.notifier).editContact(
          addressBookId: addressBookId,
          groupId: groupId,
          ownerName: widget.contact.ownerName ?? '',
          addressBook: widget.contact.addressBook ?? '',
          onError: (error) {
            if (!mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error)));
          },
        );

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      Navigator.pop(context, groupId);
    }
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
                  final name = _newGroupController.text.trim();
                  if (name.isEmpty) return;
                  ref.read(emailGroupNotifier.notifier).addEmailGroup(
                        groupName: name,
                        onError: (error) {
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(error)));
                        },
                        onSuccess: (message) {
                          _newGroupController.clear();
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

  @override
  Widget build(BuildContext context) {
    final isLoadingGroups = ref.watch(
      emailGroupNotifier.select((v) => v.state == LoadState.loading),
    );
    final groups = ref.watch(
      emailGroupNotifier.select((v) => v.data?.data ?? <EmailGroupData>[]),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add ${widget.contact.ownerName ?? 'contact'} to group',
      ),
      body: PageLoader(
        isLoading: _isSaving,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: isLoadingGroups && groups.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : groups.isEmpty
                        ? Center(
                            child: Text(
                              'No groups yet',
                              style: context.textTheme.s14w400
                                  .copyWith(color: Colors.grey[600]),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            itemCount: groups.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, index) {
                              final group = groups[index];
                              final isSelected =
                                  _selectedGroupId == group.groupId;
                              return RadioListTile<int>(
                                contentPadding: EdgeInsets.zero,
                                value: group.groupId ?? -1,
                                groupValue: _selectedGroupId,
                                activeColor: AppColors.primaryColor,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text(group.groupName ?? '',
                                    style: context.textTheme.s14w500),
                                subtitle: Text(
                                  '${group.totalAddressBooks ?? 0} contacts',
                                  style: context.textTheme.s12w400
                                      .copyWith(color: Colors.grey[600]),
                                ),
                                selected: isSelected,
                                onChanged: (value) => setState(() {
                                  _selectedGroupId = value;
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
