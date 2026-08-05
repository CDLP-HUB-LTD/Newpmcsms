// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pmcsms/core/extensions/build_context_extension.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/presentation/features/fund_wallet/presentation/view/fund_wallet_option.dart';
// import 'package:pmcsms/presentation/features/kyc/presentation/view/kyc_view.dart';
// import 'package:pmcsms/presentation/features/transaction_pin/presentation/views/set_transaction_pin.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class AccountSetUpSection extends StatefulWidget {
//   const AccountSetUpSection({super.key});

//   @override
//   State<AccountSetUpSection> createState() => _AccountSetUpSectionState();
// }

// class _AccountSetUpSectionState extends State<AccountSetUpSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(12), topRight: Radius.circular(12)),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Account Setup',
//                   style: context.textTheme.s16w500
//                       .copyWith(color: AppColors.black),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: AppColors.primaryF5F5F5,
//                     ),
//                     child: SvgPicture.asset('assets/icons/cancel.svg'),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const Divider(color: AppColors.primaryE8E8E8),
//           const VerticalSpacing(12),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       height: 7,
//                       width: MediaQuery.of(context).size.width * 0.8,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(87),
//                         color: AppColors.primaryE6E5E5,
//                       ),
//                       child: LinearProgressIndicator(
//                         value: 0.3,
//                         borderRadius: BorderRadius.circular(87),
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                     Text(
//                       '50%',
//                       style: context.textTheme.s14w400
//                           .copyWith(color: AppColors.primary494949),
//                     )
//                   ],
//                 ),
//                 const VerticalSpacing(15),
//                 SetupAccountWidget(
//                   title: 'Create transaction pin',
//                   subTitle: 'Set up a pin for your transactions',
//                   onTap: () => context.pushNamed(SetTransactionPin.routeName),
//                 ),
//                 const VerticalSpacing(25),
//                 SetupAccountWidget(
//                     title: 'Start your Kyc',
//                     subTitle: 'Let’s verify your identity',
//                     onTap: () => context.pushNamed(KycView.routeName)),
//                 const VerticalSpacing(25),
//                 SetupAccountWidget(
//                   title: 'Fund your wallet',
//                   subTitle: 'Top your wallet with a bank transfer or ATM',
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       backgroundColor: Colors.transparent,
//                       builder: (context) => const FundAccountOptions(),
//                     );
//                   },
//                 ),
//                 const VerticalSpacing(25),
//                 const SetupAccountWidget(
//                   title: 'User ID',
//                   subTitle: 'Create a user ID',
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class SetupAccountWidget extends StatelessWidget {
//   const SetupAccountWidget(
//       {super.key, required this.title, required this.subTitle, this.onTap});
//   final String title;
//   final String subTitle;
//   final Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               SvgPicture.asset('assets/icons/setup_icon.svg'),
//               const HorizontalSpacing(15),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: context.textTheme.s14w600
//                           .copyWith(color: AppColors.primary1C1C1C)),
//                   const VerticalSpacing(1),
//                   Text(subTitle,
//                       style: context.textTheme.s12w400
//                           .copyWith(color: AppColors.primary676767)),
//                 ],
//               ),
//             ],
//           ),
//           const Icon(Icons.arrow_forward_ios,
//               color: AppColors.primary676767, size: 18)
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Added Riverpod import
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/fund_wallet/presentation/view/fund_wallet_option.dart';
import 'package:pmcsms/presentation/features/kyc/presentation/view/kyc_view.dart';
// ✅ Import your KYC provider path profile here to read your completion level
import 'package:pmcsms/presentation/features/kyc/presentation/notifier/kyc_status_notifier.dart';
import 'package:pmcsms/presentation/features/transaction_pin/presentation/views/set_transaction_pin.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// ✅ Converted from StatefulWidget to ConsumerStatefulWidget
class AccountSetUpSection extends ConsumerStatefulWidget {
  const AccountSetUpSection({super.key});

  @override
  ConsumerState<AccountSetUpSection> createState() =>
      _AccountSetUpSectionState();
}

class _AccountSetUpSectionState extends ConsumerState<AccountSetUpSection> {
  @override
  Widget build(BuildContext context) {
    // ✅ Watch your live KYC data stream (defaulting to 0.0 if loading or unverified)
    // Inside your _AccountSetUpSectionState build method:

    final kycState = ref.watch(kycStatusNotifierProvider);
    final double kycLevel = kycState.maybeWhen(
      data: (response) {
        final kycData = response?.data;
        if (kycData == null) return 0.0;

        // Mirrors the exact business logic evaluation from your KycView
        final bool hasBvn = kycData.hasBvn == true;
        final bool hasNin = kycData.hasNin == true;

        if (hasBvn && hasNin) {
          return 1.0;
        } else if (hasBvn || hasNin) {
          return 0.5;
        }
        return 0.0;
      },
      orElse: () =>
          0.0, // Defaults smoothly to 0% during initial loads or errors
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures modal snaps to content height
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account Setup',
                  style: context.textTheme.s16w500
                      .copyWith(color: AppColors.black),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryF5F5F5,
                    ),
                    child: SvgPicture.asset('assets/icons/cancel.svg'),
                  ),
                )
              ],
            ),
          ),
          const Divider(color: AppColors.primaryE8E8E8),
          const VerticalSpacing(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 12
                            .h, // ✅ This will now compile with ScreenUtil imported
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryE6E6E6,
                        ),
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(8),
                          value: kycLevel,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryF9BC1F,
                          ),
                        ),
                      ),
                    ),
                    const HorizontalSpacing(16),
                    // ✅ Fixed duplicate 'Text(' syntax compile error
                    Text(
                      '${(kycLevel * 100).toInt()}%',
                      style: context.textTheme.s14w600.copyWith(
                        color: AppColors.black,
                      ),
                    )
                  ],
                ),
                const VerticalSpacing(15),
                SetupAccountWidget(
                  title: 'Create transaction pin',
                  subTitle: 'Set up a pin for your transactions',
                  onTap: () => context.pushNamed(SetTransactionPin.routeName),
                ),
                const VerticalSpacing(25),
                SetupAccountWidget(
                  title: 'Start your Kyc',
                  subTitle: 'Let’s verify your identity',
                  onTap: () => context.pushNamed(KycView.routeName),
                ),
                const VerticalSpacing(25),
                SetupAccountWidget(
                  title: 'Fund your wallet',
                  subTitle: 'Top your wallet with a bank transfer or ATM',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FundAccountOptions(),
                    );
                  },
                ),
                const VerticalSpacing(25),
                const SetupAccountWidget(
                  title: 'User ID',
                  subTitle: 'Create a user ID',
                ),
                const VerticalSpacing(
                    24), // Added trailing padding for bottom overflow protection
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SetupAccountWidget extends StatelessWidget {
  const SetupAccountWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8), // Cleans tap feedback edges
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 4), // Makes target slightly easier to hit
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/setup_icon.svg'),
                  const HorizontalSpacing(15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textTheme.s14w600
                              .copyWith(color: AppColors.primary1C1C1C),
                        ),
                        const VerticalSpacing(1),
                        Text(
                          subTitle,
                          style: context.textTheme.s12w400
                              .copyWith(color: AppColors.primary676767),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary676767,
              size: 14,
            )
          ],
        ),
      ),
    );
  }
}
