import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/network/dio_client.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/data/data/local_data_source/local_storage_impl.dart';
import 'package:pmcsms/presentation/features/referral/presentation/model/referral_response.dart';
import 'package:pmcsms/presentation/features/referral/presentation/notifier/referral_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class ReferralsView extends ConsumerStatefulWidget {
  const ReferralsView({super.key});
  static const String routeName = '/referrals';

  @override
  ConsumerState<ReferralsView> createState() => _ReferralsViewState();
}

class _ReferralsViewState extends ConsumerState<ReferralsView> {
  String? _referralCode;
  bool _isLoadingReferralCode = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(referralNotifier.notifier).getMyReferrals(start: 1, length: 20);
      _loadReferralCode();
    });
  }

  Future<void> _loadReferralCode() async {
    final storage = ref.read(localStorageProvider);
    final loginResponse = await storage.getLoginResponse();
    final code = loginResponse?.data?.referralCode;

    if (!mounted) return;
    setState(() {
      _referralCode = code;
      _isLoadingReferralCode = false;
    });
  }

  String get _referralLink {
    if (_referralCode == null || _referralCode!.isEmpty) return '';
    final baseUrl = ref.read(appEnvProvider).baseUrl;
    return '$baseUrl/#/register/$_referralCode';
  }

  @override
  Widget build(BuildContext context) {
    final referralState = ref.watch(referralNotifier);
    final isLoading = referralState.state == LoadState.loading;
    final referrals = referralState.data?.data ?? <ReferralItem>[];

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
                            child: _isLoadingReferralCode
                                ? SizedBox(
                                    height: 14.h,
                                    width: 14.h,
                                    child: const CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Text(
                                    _referralLink.isNotEmpty
                                        ? _referralLink
                                        : 'Referral code unavailable',
                                    style: context.textTheme.s12w400,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          if (!_isLoadingReferralCode &&
                              _referralLink.isNotEmpty)
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: _referralLink));
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
                      'Your Referrals (${referrals.length})',
                      style: context.textTheme.s14w600,
                    ),
                    const VerticalSpacing(16),
                    if (isLoading && referrals.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (referrals.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No referrals yet',
                            style: context.textTheme.s12w400
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: referrals.length,
                        separatorBuilder: (_, __) => const VerticalSpacing(16),
                        itemBuilder: (context, index) {
                          final referral = referrals[index];
                          final isConfirmed = referral.confirmed;
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
                                      referral.username,
                                      style: context.textTheme.s12w600,
                                    ),
                                    Text(
                                      referral.regDate,
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
                                  color: isConfirmed
                                      ? Colors.green.shade50
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  isConfirmed ? 'Confirmed' : 'Pending',
                                  style: context.textTheme.s10w500.copyWith(
                                    color: isConfirmed
                                        ? Colors.green
                                        : Colors.grey[700],
                                  ),
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
