import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class ReferralsView extends ConsumerStatefulWidget {
  const ReferralsView({super.key});
  static const String routeName = '/referrals';

  @override
  ConsumerState<ReferralsView> createState() => _ReferralsViewState();
}

class _ReferralsViewState extends ConsumerState<ReferralsView> {
  final String _referralCode = 'http://superjara.com/#/register/...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Referrals'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Referral Link Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 40.r,
                      color: Colors.redAccent,
                    ),
                    const VerticalSpacing(8),
                    Text(
                      'Your Referral Code',
                      style: context.textTheme.s12w500
                          .copyWith(color: Colors.grey),
                    ),
                    const VerticalSpacing(12),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.primaryE6E6E6),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _referralCode,
                              style: context.textTheme.s12w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: _referralCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Referral link copied!')),
                              );
                            },
                            child: Icon(Icons.copy,
                                size: 18.r, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpacing(20),

              // Referrals List Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Referrals (4)',
                      style: context.textTheme.s14w600,
                    ),
                    const VerticalSpacing(16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      separatorBuilder: (_, __) => const VerticalSpacing(16),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colors.amber.shade200,
                              child: Icon(Icons.person,
                                  size: 20.r, color: Colors.brown),
                            ),
                            const HorizontalSpacing(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Peace Adedokun',
                                    style: context.textTheme.s12w600,
                                  ),
                                  Text(
                                    'peaceadedokun@gmail.com',
                                    style: context.textTheme.s10w400
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Active',
                                style: context.textTheme.s10w500
                                    .copyWith(color: Colors.green),
                              ),
                            ),
                          ],
                        );
                      },
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
