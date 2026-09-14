import 'package:flutter/material.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/analytics/view/analytics_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/more/presentation/widgets/option_widget.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/more/presentation/widgets/profile_option_widget.dart';
import 'package:pmcsms/presentation/features/faq/presentation/faq_view.dart';
import 'package:pmcsms/presentation/features/history/views/history_view.dart';
import 'package:pmcsms/presentation/features/kyc/presentation/view/kyc_view.dart';
import 'package:pmcsms/presentation/features/manage_account/presentation/view/manage_account_view.dart';
import 'package:pmcsms/presentation/features/notification/views/notification_settings.dart';
import 'package:pmcsms/presentation/features/referral/views/referrals_view.dart';
import 'package:pmcsms/presentation/features/reset_password/change_password/view/change_password_view.dart';
import 'package:pmcsms/presentation/features/senderid/views/sender_id_view.dart';
import 'package:pmcsms/presentation/features/transaction_pin/presentation/views/change_payment_pin_view.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class MoreOptionSection extends StatelessWidget {
  const MoreOptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileOptionWidget(
            title: 'ACCOUNT',
            children: [
              OptionWidget(
                onTap: () => context.pushNamed(ManageAccountView.routeName),
                icon: 'assets/icons/edit.svg',
                title: 'Manage account',
              ),
              const VerticalSpacing(20),
              OptionWidget(
                onTap: () => context.pushNamed(KycView.routeName),
                icon: 'assets/icons/kyc.svg',
                title: 'KYC verification',
              )
            ],
          ),
          const VerticalSpacing(48),
          ProfileOptionWidget(
            title: 'SERVICES',
            children: [
              OptionWidget(
                icon: 'assets/icons/referrals.svg',
                title: 'Referrals',
                onTap: () {
                  Navigator.pushNamed(context, ReferralsView.routeName);
                },
              ),
              const VerticalSpacing(20),
              OptionWidget(
                icon: 'assets/icons/user_id.svg',
                title: 'SENDER ID',
                onTap: () {
                  Navigator.pushNamed(context, SenderIdView.routeName);
                },
              ),
              const VerticalSpacing(20),
              OptionWidget(
                icon: 'assets/icons/user_id.svg',
                title: 'Messaging history ',
                onTap: () {
                  Navigator.pushNamed(context, HistoryView.routeName);
                },
              ),
              const VerticalSpacing(20),
              OptionWidget(
                icon: 'assets/icons/analytics.svg',
                title: 'Analytics',
                onTap: () {
                  Navigator.pushNamed(context, AnalyticsView.routeName);
                },
              ),
            ],
          ),
          const VerticalSpacing(48),
          const ProfileOptionWidget(
            title: 'LEGAL',
            children: [
              OptionWidget(
                icon: 'assets/icons/terms.svg',
                title: 'Terms of use',
              ),
              VerticalSpacing(20),
              OptionWidget(
                icon: 'assets/icons/privacy_policy.svg',
                title: 'Privacy policy',
              ),
            ],
          ),
          const VerticalSpacing(48),
          ProfileOptionWidget(
            title: 'HELP & SUPPORT',
            children: [
              const OptionWidget(
                icon: 'assets/icons/support.svg',
                title: 'Contact support',
              ),
              const VerticalSpacing(20),
              OptionWidget(
                onTap: () => context.pushNamed(FaqView.routeName),
                icon: 'assets/icons/faq.svg',
                title: 'Frequently asked questions',
              ),
            ],
          ),
          const VerticalSpacing(48),
          ProfileOptionWidget(
            title: 'SECURITY & PREFRENCE',
            children: [
              OptionWidget(
                icon: 'assets/icons/lock.svg',
                title: 'Change password',
                onTap: () {
                  Navigator.pushNamed(context, ChangePasswordView.routeName);
                },
              ),
              const VerticalSpacing(20),
              OptionWidget(
                icon: 'assets/icons/reset_pin.svg',
                title: 'Reset transaction pin',
                onTap: () {
                  Navigator.pushNamed(context, ChangePaymentPinView.routeName);
                },
              ),
              const VerticalSpacing(20),
              OptionWidget(
                icon: 'assets/icons/notification_settings.svg',
                title: 'Notification settings ',
                onTap: () {
                  Navigator.pushNamed(
                      context, NotificationSettingView.routeName);
                },
              ),
            ],
          ),
          const VerticalSpacing(57),
          Center(
            child: Text(
              'PMCSMS APP VERSION 1.0',
              style: context.textTheme.s12w300.copyWith(
                color: AppColors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
