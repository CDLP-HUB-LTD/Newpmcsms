import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/phonebook/data/model/edit_address_book_request.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/edit_contact_notifier.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/notifier/get_all_phone_book_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/amount_textfield.dart';
import 'package:pmcsms/presentation/general_widgets/app_form_field.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class EditContactView extends ConsumerStatefulWidget {
  final int addressBookId;
  final int groupId;
  final String initialName;
  final String initialPhone;

  const EditContactView({
    super.key,
    required this.addressBookId,
    required this.groupId,
    required this.initialName,
    required this.initialPhone,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditContactViewState();
}

class _EditContactViewState extends ConsumerState<EditContactView> {
  late final _nameController = TextEditingController(text: widget.initialName);
  late final _phoneController =
      TextEditingController(text: widget.initialPhone);

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      editContactNotifier.select((v) => v.state == LoadState.loading),
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
                  'Edit',
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
                Text(
                  'Phone number',
                  style: context.textTheme.s14w400
                      .copyWith(color: AppColors.primary0F0F0F),
                ),
                const VerticalSpacing(8),
                AmountTextField(
                  amountController: _phoneController,
                  hintText: '',
                  maxLength: 11,
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
    final data = EditAddressBookRequest(
      addressBookId: widget.addressBookId,
      addressBook: _phoneController.text.trim(),
      groupId: widget.groupId,
    );

    ref.read(editContactNotifier.notifier).editContact(
          data: data,
          onError: (error) => context.showError(message: error),
          onSuccess: (message) {
            context.showSuccess(message: message);
            Navigator.pop(context);
            ref.read(getAllContactsNotifier.notifier).getAllContacts();
          },
        );
  }
}
