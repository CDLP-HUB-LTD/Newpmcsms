// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/notifier/get_balance_notifier.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/notifier/hide_balance_provider.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/home/widgets/recent_transaction_section.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/home/widgets/transfer_funds_wallet_buttons.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class WalletComponent extends ConsumerStatefulWidget {
//   const WalletComponent({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _WalletComponentState();
// }

// class _WalletComponentState extends ConsumerState<WalletComponent> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await ref.read(getWalletBalanceNotifier.notifier).getWalletBalance();
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final walletBalance = ref.watch(getWalletBalanceNotifier.select((v) {
//       // NOTE: the real response names this entry "Naira Balance"
//       // (credit_type: wallet, currency: NGN) — not "Wallet Balance". The
//       // filter previously looked for the wrong name, so it always matched
//       // nothing and the display fell back to null.
//       final balanceList = v.getBalanceResponse?.data?.balance
//           ?.where((e) => e.name?.toLowerCase() == 'naira balance')
//           .map((e) => e.value)
//           .toSet()
//           .toList();

//       if (balanceList != null && balanceList.isNotEmpty) {
//         final balanceValue = balanceList.first;
//         // The real "value" field comes back as a plain number
//         // (e.g. 18510424.51), not a parenthesised string like
//         // "(800000.00)" — this strips parentheses if present so it still
//         // works either way, whether `value` is a String or a num.
//         final balanceString = balanceValue.toString();
//         final cleanedBalance =
//             balanceString.replaceAll(RegExp(r'[()]'), '').trim();
//         return cleanedBalance;
//       }

//       return null; // or a default value if no balance is found
//     }));
//     final hideBalance = ref.watch(hideBalanceProvider);
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 24),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 80),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryFEFFEB,
//                     borderRadius: BorderRadius.circular(58),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset('assets/icons/wallet.svg'),
//                       const HorizontalSpacing(5),
//                       Text(
//                         'Wallet Balance',
//                         style: context.textTheme.s12w400.copyWith(
//                           color: AppColors.primary1C1C1C,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const VerticalSpacing(20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '\u20a6 ${hideBalance ? '****' : walletBalance}',
//                       style: context.textTheme.s20w600.copyWith(
//                         color: AppColors.primary141414,
//                       ),
//                     ),
//                     const HorizontalSpacing(5),
//                     GestureDetector(
//                       onTap: () {
//                         ref.read(hideBalanceProvider.notifier).state =
//                             !hideBalance;
//                       },
//                       child: Icon(
//                           hideBalance
//                               ? Icons.visibility_off_outlined
//                               : Icons.visibility_outlined,
//                           color: AppColors.primary141414,
//                           size: 20),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           const VerticalSpacing(20),
//           const TransferFundsWalletButtons(),
//           const VerticalSpacing(40),
//           const RecentTransactionSection(
//             walletList: [],
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/data/model/wallet_history_response.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/notifier/get_balance_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/notifier/hide_balance_provider.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/home/widgets/recent_transaction_section.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/home/widgets/transfer_funds_wallet_buttons.dart';
import 'package:pmcsms/presentation/features/transactions/data/model/wallet_history_request.dart';
import 'package:pmcsms/presentation/features/transactions/data/model/wallet_history_response.dart';
import 'package:pmcsms/presentation/features/transactions/presentation/notifier/get_wallet_history_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class WalletComponent extends ConsumerStatefulWidget {
  const WalletComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletComponentState();
}

class _WalletComponentState extends ConsumerState<WalletComponent> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getWalletBalanceNotifier.notifier).getWalletBalance();
      // NOTE: length: 5 keeps this home-screen preview short — the full
      // list still lives on TransactionView via its own fetch. Confirmed
      // request shape: process: pm_wallet, action: wallet_history (GET).
      await ref.read(getWalletHistoryNotifier.notifier).getWalletHistory(
            data: WalletHistoryRequest(
              process: 'pm_wallet',
              action: 'wallet_history',
              length: 5,
            ),
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final walletBalance = ref.watch(getWalletBalanceNotifier.select((v) {
      // NOTE: the real response names this entry "Naira Balance"
      // (credit_type: wallet, currency: NGN) — not "Wallet Balance". The
      // filter previously looked for the wrong name, so it always matched
      // nothing and the display fell back to null.
      final balanceList = v.getBalanceResponse?.data?.balance
          ?.where((e) => e.name?.toLowerCase() == 'naira balance')
          .map((e) => e.value)
          .toSet()
          .toList();

      if (balanceList != null && balanceList.isNotEmpty) {
        final balanceValue = balanceList.first;
        // The real "value" field comes back as a plain number
        // (e.g. 18510424.51), not a parenthesised string like
        // "(800000.00)" — this strips parentheses if present so it still
        // works either way, whether `value` is a String or a num.
        final balanceString = balanceValue.toString();
        final cleanedBalance =
            balanceString.replaceAll(RegExp(r'[()]'), '').trim();
        return cleanedBalance;
      }

      return null; // or a default value if no balance is found
    }));
    final hideBalance = ref.watch(hideBalanceProvider);

    // Previously hardcoded to []. History is nested under
    // WalletHistoryResponse.data.history.
    final walletHistory = ref.watch(getWalletHistoryNotifier.select((v) =>
        v.data?.data?.history?.cast<UserWalletHistory>() ??
        const <UserWalletHistory>[]));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 80),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFEFFEB,
                    borderRadius: BorderRadius.circular(58),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/wallet.svg'),
                      const HorizontalSpacing(5),
                      Text(
                        'Wallet Balance',
                        style: context.textTheme.s12w400.copyWith(
                          color: AppColors.primary1C1C1C,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpacing(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\u20a6 ${hideBalance ? '****' : walletBalance}',
                      style: context.textTheme.s20w600.copyWith(
                        color: AppColors.primary141414,
                      ),
                    ),
                    const HorizontalSpacing(5),
                    GestureDetector(
                      onTap: () {
                        ref.read(hideBalanceProvider.notifier).state =
                            !hideBalance;
                      },
                      child: Icon(
                          hideBalance
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.primary141414,
                          size: 20),
                    ),
                  ],
                )
              ],
            ),
          ),
          const VerticalSpacing(20),
          const TransferFundsWalletButtons(),
          const VerticalSpacing(40),
          RecentTransactionSection(
            walletList: walletHistory,
          )
        ],
      ),
    );
  }
}
