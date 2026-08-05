import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/contact/presentation/widgets/manage_contact_section.dart';
import 'package:pmcsms/presentation/features/email_list/view/email_list_view.dart';
import 'package:pmcsms/presentation/features/phonebook/presentation/view/phonebook_view.dart';
import 'package:pmcsms/presentation/general_widgets/app_options_button_widget.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class ContactView extends ConsumerStatefulWidget {
  const ContactView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactViewState();
}

class _ContactViewState extends ConsumerState<ContactView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Contact',
        leading: SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            children: [
              const ManageContactSection(),
              const VerticalSpacing(24),
              AppOptionsButtonWidget(
                onTap: () => context.pushNamed(PhonebookView.routeName),
                iconContainerColor: AppColors.primaryFFFDE6,
                icon: 'assets/icons/phone_book.svg',
                title: 'Phone book',
                subTitle: 'View and edit contacts save to phone book',
                containerColor: AppColors.primaryF5F7F9,
              ),
              const VerticalSpacing(24),
              AppOptionsButtonWidget(
                onTap: () => context.pushNamed(EmailListView.routeName),
                iconContainerColor: AppColors.primaryE6F8FE,
                icon: 'assets/icons/mail.svg',
                title: 'Email List',
                subTitle: 'View and edit contacts save to email list',
                containerColor: AppColors.primaryF5F7F9,
              )
            ],
          ),
        ),
      ),
    );
  }
}
