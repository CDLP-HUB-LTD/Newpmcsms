// lib/presentation/features/email_list/view/edit_email_contact_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/email_list/presentation/notifier/email_list_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/app_form_field.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Edit screen for an EMAIL contact — name + email address.
/// (Not to be confused with the phonebook feature's EditContactView, which
/// edits a phone number through a different notifier/endpoint.)
class EditEmailContactView extends ConsumerStatefulWidget {
  final int addressBookId;
  final int groupId;
  final String initialName;
  final String initialEmail;

  const EditEmailContactView({
    super.key,
    required this.addressBookId,
    required this.groupId,
    required this.initialName,
    required this.initialEmail,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditEmailContactViewState();
}

class _EditEmailContactViewState extends ConsumerState<EditEmailContactView> {
  late final _nameController = TextEditingController(text: widget.initialName);
  late final _emailController =
      TextEditingController(text: widget.initialEmail);

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
                  'Edit contact',
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
    if (name.isEmpty || email.isEmpty) {
      context.showError(message: 'Name and email are required');
      return;
    }
    if (widget.addressBookId == 0) {
      context.showError(
          message:
              'Missing contact ID — cannot save. Please refresh the list and try again.');
      return;
    }

    ref.read(emailListNotifier.notifier).editContact(
          addressBookId: widget.addressBookId,
          groupId: widget.groupId,
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
