import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/notifier/get_balance_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/notifier/hide_balance_provider.dart';
import 'package:pmcsms/presentation/features/transactions/presentation/view/transaction_view.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalletBalanceSection extends ConsumerStatefulWidget {
  const WalletBalanceSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletBalanceSectionState();
}

class _WalletBalanceSectionState extends ConsumerState<WalletBalanceSection> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    // Restored — this is what actually triggers process=pm_wallet,
    // action=balance. Without this the widget never has real data.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getWalletBalanceNotifier.notifier).getWalletBalance();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Strips the parentheses the API wraps balance values in, e.g.
  /// "(800000.00)" -> "800000.00". Same cleanup WalletComponent does.
  String _cleanValue(String? raw) {
    if (raw == null) return '0.00';
    return raw.replaceAll(RegExp(r'[()]'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final balanceState = ref.watch(getWalletBalanceNotifier);
    final balance = balanceState.getBalanceResponse;
    final hideBalance = ref.watch(hideBalanceProvider);

    final rawBalanceList = balance?.data?.balance;
    final isLoading = balanceState
        is AsyncLoading; // Replace with the correct loading state check
    final hasData = rawBalanceList != null && rawBalanceList.isNotEmpty;
    return Animate(
      effects: const [
        FadeEffect(
          delay: Duration(milliseconds: 200),
          duration: Duration(milliseconds: 500),
        ),
      ],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.black.withOpacity(0.03)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(2, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 110.h,
              child: !hasData
                  ? Center(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'No balance data available',
                              style: context.textTheme.s12w400
                                  .copyWith(color: Colors.grey),
                            ),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: rawBalanceList.length,
                      itemBuilder: (context, index) {
                        final data = rawBalanceList[index];
                        final displayValue =
                            hideBalance ? '******' : _cleanValue(data.value);

                        return Column(
                          children: [
                            Container(
                              width: 170.w,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryEBF2FF,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/wallet.svg'),
                                  const HorizontalSpacing(5),
                                  Text(
                                    '${data.name}',
                                    style: context.textTheme.s12w400.copyWith(
                                      color: AppColors.primary1C1C1C,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const VerticalSpacing(14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '\u20a6 $displayValue',
                                  style: context.textTheme.s20w600.copyWith(
                                    color: AppColors.primary141414,
                                  ),
                                ),
                                const HorizontalSpacing(12),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(hideBalanceProvider.notifier)
                                        .state = !hideBalance;
                                  },
                                  child: SvgPicture.asset(
                                    hideBalance
                                        ? 'assets/icons/eye-slash.svg'
                                        : 'assets/icons/eye.svg',
                                    width: 20.w,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
            ),
            if (hasData) ...[
              SmoothPageIndicator(
                controller: _pageController,
                count: rawBalanceList.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 4,
                  dotWidth: 7,
                  radius: 5,
                  activeDotColor: AppColors.primary676767,
                  dotColor: AppColors.primaryD9D9D9,
                ),
              ),
            ],
            const VerticalSpacing(12),
            Divider(color: AppColors.primaryE8E8E8.withOpacity(0.55)),
            const VerticalSpacing(8),
            InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(TransactionView.routeName),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View history',
                    style: context.textTheme.s12w400.copyWith(
                      color: AppColors.primary494949,
                    ),
                  ),
                  const HorizontalSpacing(4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: AppColors.primary494949,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
