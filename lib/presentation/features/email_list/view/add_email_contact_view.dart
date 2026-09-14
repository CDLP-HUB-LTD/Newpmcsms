// lib/presentation/features/email_list/view/add_email_contact_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/models/email_group.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/notifier/email_group_notifier.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/notifier/email_list_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/app_form_field.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Add screen for an EMAIL contact — name, email address(es), and group.
/// (Not the dashboard/contact feature's AddContactView, which adds a phone
/// number through a different notifier/endpoint.)
///
/// `add_email_address_book` requires a group_id up front, and supports
/// adding several emails at once as a comma-separated string — so this
/// screen collects both.
class AddEmailContactView extends ConsumerStatefulWidget {
  const AddEmailContactView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddEmailContactViewState();
}

class _AddEmailContactViewState extends ConsumerState<AddEmailContactView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  int? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(emailGroupNotifier.notifier).getEmailGroups();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      emailListNotifier.select((v) => v.submitState == LoadState.loading),
    );
    final groups = ref.watch(
      emailGroupNotifier.select((v) => v.data?.data ?? <EmailGroupData>[]),
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add contact',
                  style: context.textTheme.s16w500
                      .copyWith(color: AppColors.black),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.primaryF5F5F5),
                    child: SvgPicture.asset('assets/icons/cancel.svg'),
                  ),
                )
              ],
            ),
          ),
          const Divider(color: AppColors.primaryE8E8E8),
          const VerticalSpacing(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppFormField(label: 'Name', controller: _nameController),
                const VerticalSpacing(24),
                AppFormField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'name@example.com, another@example.com',
                ),
                const VerticalSpacing(24),
                Text(
                  'Group',
                  style: context.textTheme.s14w400
                      .copyWith(color: AppColors.primary0F0F0F),
                ),
                const VerticalSpacing(8),
                DropdownButtonFormField<int>(
                  initialValue: _selectedGroupId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryF5F7F9,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: groups.isEmpty
                        ? 'No groups available'
                        : 'Select a group',
                  ),
                  items: groups
                      .where((g) => g.groupId != null)
                      .map(
                        (g) => DropdownMenuItem<int>(
                          value: g.groupId,
                          child: Text(g.groupName ?? ''),
                        ),
                      )
                      .toList(),
                  onChanged: groups.isEmpty
                      ? null
                      : (value) => setState(() => _selectedGroupId = value),
                ),
                const VerticalSpacing(30),
                AppSendButton(
                  isEnabled: !isLoading,
                  onTap: _saveContact,
                  title: isLoading ? 'Saving...' : 'Save',
                ),
                const VerticalSpacing(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveContact() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final groupId = _selectedGroupId;

    if (name.isEmpty || email.isEmpty) {
      context.showError(message: 'Name and email are required');
      return;
    }
    if (groupId == null) {
      context.showError(message: 'Please select a group');
      return;
    }

    ref.read(emailListNotifier.notifier).addContact(
          groupId: groupId,
          ownerName: name,
          addressBook: email,
          onError: (error) => context.showError(message: error),
          onSuccess: (message) {
            context.showSuccess(message: message);
            Navigator.pop(context);
          },
        );
  }
}
