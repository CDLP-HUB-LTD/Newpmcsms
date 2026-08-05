// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/data/data/local_data_source/local_storage_impl.dart';
// import 'package:pmcsms/presentation/features/login/data/model/login_response.dart';
// import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class KycView extends ConsumerStatefulWidget {
//   const KycView({super.key});
//   static const String routeName = '/kyc';

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _KycViewState();
// }

// class _KycViewState extends ConsumerState<KycView> {
//   LoginResponse? _loginResponse;
//   double kycLevel = 0;

//   @override
//   void initState() {
//     getResponse();
//     getUserKycStatus();
//     super.initState();
//   }

//   getResponse() async {
//     _loginResponse = await SecureStorage().getLoginResponse();
//   }

//   getUserKycStatus() {
//     if (_loginResponse?.data?.kyc?.isNinVerified == 'yes' &&
//         _loginResponse?.data?.kyc?.isBvnVerified == 'yes') {
//       setState(() {
//         kycLevel = 1;
//       });
//     } else if (_loginResponse?.data?.kyc?.isNinVerified == 'yes' ||
//         _loginResponse?.data?.kyc?.isBvnVerified == 'no') {
//       setState(() {
//         kycLevel = 0.5;
//       });
//     } else if (_loginResponse?.data?.kyc?.isNinVerified == 'no' ||
//         _loginResponse?.data?.kyc?.isBvnVerified == 'yes') {
//       setState(() {
//         kycLevel = 0.5;
//       });
//     } else {
//       setState(() {
//         kycLevel = 0;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: 'KYC',
//       ),
//       body: SafeArea(
//           child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 38),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   height: 15.h,
//                   width: MediaQuery.of(context).size.width * 0.75,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: AppColors.primaryE6E6E6,
//                   ),
//                   child: LinearProgressIndicator(
//                     borderRadius: BorderRadius.circular(8),
//                     value: kycLevel,
//                     color: AppColors.primaryF9BC1F,
//                   ),
//                 ),
//                 const HorizontalSpacing(20),
//                 Text(
//                   '${(kycLevel * 100).toInt()}%',
//                   style: context.textTheme.s14w500.copyWith(
//                     color: AppColors.black,
//                   ),
//                 )
//               ],
//             ),
//             const VerticalSpacing(25),
//             Expanded(
//               child: ListView.builder(itemBuilder: (_, index) {
//                 return Container();
//               }),
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }

// class KycTypeWidget extends StatelessWidget {
//   const KycTypeWidget({super.key, required this.icon});
//   final String icon;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
//         decoration: const BoxDecoration(color: AppColors.primaryF5F7F9),
//         child: Row(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                     color: AppColors.black,
//                   )),
//                   child: Container(
//                     height: 10,
//                     width: 10,
//                     decoration: const BoxDecoration(
//                         color: AppColors.black, shape: BoxShape.circle),
//                   ),
//                 ),
//                 const HorizontalSpacing(16),
//                 SvgPicture.asset(icon)
//               ],
//             ),
//           ],
//         ));
//   }
// }i

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/data/data/local_data_source/local_storage_impl.dart';
import 'package:pmcsms/presentation/features/kyc/presentation/notifier/kyc_status_notifier.dart';
import 'package:pmcsms/presentation/features/kyc/presentation/view/bvn_verification_screen.dart';
import 'package:pmcsms/presentation/features/kyc/presentation/view/nin_verification_screen.dart';
import 'package:pmcsms/presentation/features/login/data/model/login_response.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class KycView extends ConsumerStatefulWidget {
  const KycView({super.key});
  static const String routeName = '/kyc';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KycViewState();
}

class _KycViewState extends ConsumerState<KycView> {
  LoginResponse? _loginResponse;
  double kycLevel = 0;
  bool _hasBvnVerified = false;
  final SecureStorage _secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _initKycData();
  }

  Future<void> _initKycData() async {
    // 1. Await local data first for immediate UI layout
    await getResponse();
    getUserKycStatus();

    // 2. Fetch fresh real-time verification parameters from backend engine via GET
    _fetchRemoteKycStatus();
  }

  Future<void> getResponse() async {
    _loginResponse = await _secureStorage.getLoginResponse();
  }

  void getUserKycStatus() {
    final kyc = _loginResponse?.data?.kyc;
    if (kyc == null) return;

    final nVerified = kyc.isNinVerified == 'yes';
    final bVerified = kyc.isBvnVerified == 'yes';

    setState(() {
      _hasBvnVerified = bVerified; // Maintain state fallback
      if (nVerified && bVerified) {
        kycLevel = 1.0;
      } else if (nVerified || bVerified) {
        kycLevel = 0.5;
      } else {
        kycLevel = 0.0;
      }
    });
  }

  void _fetchRemoteKycStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kycStatusNotifierProvider.notifier).getKycStatus(
        onError: (error) {
          context.showError(message: error);
        },
        onSuccess: (response) {
          final kycData = response.data;

          setState(() {
            _hasBvnVerified = kycData?.hasBvn == true;
            if (kycData?.hasBvn == true && kycData?.hasNin == true) {
              kycLevel = 1.0;
            } else if (kycData?.hasBvn == true || kycData?.hasNin == true) {
              kycLevel = 0.5;
            } else {
              kycLevel = 0.0;
            }
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define structural listing items mapped cleanly against current kycLevel states
    final kycItems = [
      _KycItemData(
          title: 'Verify Bank Verification Number (BVN)',
          subtitle:
              'Instantly link your wallet with secure tier-1 identity checks.',
          isCompleted: _hasBvnVerified,
          onTap: () {
            if (!_hasBvnVerified) {
              Navigator.pushNamed(context, BvnVerificationScreen.routeName);
            }
          }),
      _KycItemData(
        title: 'Verify National Identity Number (NIN)',
        subtitle:
            'Unlock maximum spending limit limits and full production access.',
        isCompleted: kycLevel == 1.0,
        onTap: () {
          if (kycLevel != 1.0) {
            Navigator.pushNamed(context, NinVerificationScreen.routeName);
          }
        },
      ),
    ];

    // Listen to global Riverpod loading status
    final kycState = ref.watch(kycStatusNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'KYC Verification',
      ),
      body: SafeArea(
        child: kycState.isLoading && kycLevel == 0
            ? const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryF9BC1F))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete Profile Setup',
                      style: context.textTheme.s18w600
                          .copyWith(color: AppColors.black),
                    ),
                    const VerticalSpacing(8),
                    Text(
                      'Complete verification steps to comply with CBN compliance directives.',
                      style: context.textTheme.s12w400
                          .copyWith(color: Colors.grey[600]),
                    ),
                    const VerticalSpacing(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 12.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primaryE6E6E6,
                            ),
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(8),
                              value: kycLevel,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryF9BC1F),
                            ),
                          ),
                        ),
                        const HorizontalSpacing(16),
                        Text(
                          '${(kycLevel * 100).toInt()}%',
                          style: context.textTheme.s14w600.copyWith(
                            color: AppColors.black,
                          ),
                        )
                      ],
                    ),
                    const VerticalSpacing(32),
                    Expanded(
                      child: ListView.separated(
                        itemCount: kycItems.length,
                        separatorBuilder: (_, __) => const VerticalSpacing(16),
                        itemBuilder: (_, index) {
                          final item = kycItems[index];
                          return Material(
                            // ✅ 1. Wrap with Material to provide a proper canvas for ink splashes
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            clipBehavior: Clip
                                .antiAlias, // Ensures the ink splash doesn't bleed outside the rounded corners
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: item.isCompleted
                                      ? Colors.green.withOpacity(0.3)
                                      : AppColors.primaryE6E6E6,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                onTap: item.isCompleted ? null : item.onTap,
                                // Native splash behavior now works perfectly!
                                title: Text(
                                  item.title,
                                  style: context.textTheme.s14w600.copyWith(
                                    color: AppColors.black,
                                    decoration: item.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Text(
                                    item.subtitle,
                                    style: context.textTheme.s12w400
                                        .copyWith(color: Colors.grey[500]),
                                  ),
                                ),
                                trailing: item.isCompleted
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : const Icon(Icons.arrow_forward_ios,
                                        size: 16, color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class _KycItemData {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onTap;

  _KycItemData({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.onTap,
  });
}
