// lib/presentation/features/dashboard/presentation/widgets/kyc_banner_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/kyc/presentation/notifier/kyc_status_notifier.dart';
import 'package:pmcsms/presentation/features/kyc/presentation/view/kyc_view.dart';

class KycBannerWidget extends ConsumerWidget {
  const KycBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches your existing KYC notifier state layer
    final kycState = ref.watch(kycStatusNotifierProvider);

    return kycState.maybeWhen(
      data: (response) {
        // Only show if the backend explicitly tells us to prompt the user
        if (response?.data?.showKycPrompt != true)
          return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E6), // Light warning background tint
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryF9BC1F.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.primaryF9BC1F),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KYC Verification Pending',
                      style: context.textTheme.s14w600
                          .copyWith(color: AppColors.black),
                    ),
                    Text(
                      'Verify your BVN or NIN to fully activate higher wallet limits.',
                      style: context.textTheme.s12w400
                          .copyWith(color: AppColors.primary676767),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.pushNamed(KycView.routeName),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryF9BC1F,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r)),
                ),
                child: Text(
                  'Verify',
                  style:
                      context.textTheme.s12w600.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox
          .shrink(), // Hides banner during global loading configurations
    );
  }
}
