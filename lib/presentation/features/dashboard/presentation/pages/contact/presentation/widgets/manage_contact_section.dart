import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/contact/presentation/view/add_contact_view.dart';
import 'package:pmcsms/presentation/features/email_list/view/email_list_view.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class ManageContactSection extends StatelessWidget {
  const ManageContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primary2758D4),
      child: Stack(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset('assets/icons/underline.svg')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 41.h,
                  width: 135.w,
                  child: Image.asset('assets/images/image_contacts.png'),
                ),
                const VerticalSpacing(12),
                Text(
                  'Manage Contacts',
                  style: context.textTheme.s18w600.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const VerticalSpacing(8),
                Text(
                  'Add, edit and delete the emails and phone numbers of recipients here',
                  style: context.textTheme.s12w400.copyWith(
                    color: AppColors.primaryE6E6E6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const VerticalSpacing(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: AppSendButton(
                          textColor: AppColors.primary494949,
                          backgroundColor: AppColors.white,
                          onTap: () =>
                              context.pushNamed(AddContactView.routeName),
                          title: 'Add to phone book'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: AppSendButton(
                          textColor: AppColors.primary494949,
                          backgroundColor: AppColors.white,
                          onTap: () =>
                              context.pushNamed(EmailListView.routeName),
                          title: 'Add to email list'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
