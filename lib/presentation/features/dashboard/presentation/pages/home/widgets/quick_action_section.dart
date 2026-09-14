import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart'; // Handles context.pushNamed cleanly
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/analytics/view/analytics_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/sms/presentation/view/sms_view.dart';
import 'package:pmcsms/presentation/features/senderid/views/sender_id_view.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class QuickActionSection extends StatelessWidget {
  const QuickActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: context.textTheme.s18w500.copyWith(
            color: AppColors.black,
          ),
        ),
        const VerticalSpacing(16),
        QuickActionButtonWidget(
          icon: 'assets/images/chat.png',
          title: 'Instant message',
          subTitle: 'Compose a quick sms message',
          onTap: () => context.pushNamed(SmsView.routeName),
        ),
        const VerticalSpacing(12),
        QuickActionButtonWidget(
          icon: 'assets/images/sender.png',
          title: 'Sender ID',
          subTitle: 'Create a sender ID',
          onTap: () {
            context.pushNamed(SenderIdView.routeName);
          },
        ),
        const VerticalSpacing(12),
        QuickActionButtonWidget(
          icon: 'assets/images/analytics.png',
          title: 'Analytics',
          subTitle: 'View message analytics',
          onTap: () {
            // Fires payload payload: { "process": "pm_statistics", "action": "dashboard_overview" }
            context.pushNamed(AnalyticsView.routeName);
          },
        ),
      ],
    );
  }
}

class QuickActionButtonWidget extends StatelessWidget {
  const QuickActionButtonWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.onTap, // Added required callback property handler
  });

  final String icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Swapped to InkWell inside a clean Material canvas to allow touch feedback
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.primaryF5F7F9,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // Prevents layout text overflow exceptions on small screens
              child: Row(
                children: [
                  SizedBox(
                    height: 32.h,
                    width: 32.w,
                    child: Image.asset(icon),
                  ),
                  const HorizontalSpacing(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textTheme.s14w500.copyWith(
                            color: AppColors.primary141414,
                          ),
                        ),
                        const VerticalSpacing(3),
                        Text(
                          subTitle,
                          style: context.textTheme.s12w400.copyWith(
                            color: AppColors.primary676767,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset('assets/icons/arrow_right.svg'),
          ],
        ),
      ),
    );
  }
}
