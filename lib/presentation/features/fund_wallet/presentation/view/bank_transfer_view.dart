// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/data/data/local_data_source/local_storage_impl.dart';
// import 'package:pmcsms/presentation/features/login/data/model/login_response.dart';
// import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class BankTransferView extends ConsumerStatefulWidget {
//   const BankTransferView({super.key});
//   static const String routeName = '/bankTransfer';

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _BankTransferViewState();
// }

// class _BankTransferViewState extends ConsumerState<BankTransferView> {
//   LoginResponse? response;
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       getBanksLists();
//     });
//     super.initState();
//   }

//   getBanksLists() async {
//     final loginResponse = await SecureStorage().getLoginResponse();

//     setState(() {
//       response = loginResponse;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final banksList = response?.data?.userManualAccount;
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: 'Bank Transfer',
//       ),
//       body: SafeArea(
//           child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 33,
//         ),
//         child: Column(
//           children: [
//             SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 child: ListView.builder(
//                     itemCount: banksList?.length,
//                     itemBuilder: (_, index) {
//                       final data = banksList?[index];
//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 46, horizontal: 80),
//                         decoration: BoxDecoration(
//                             color: AppColors.primaryF5F7F9,
//                             borderRadius: BorderRadius.circular(8)),
//                         child: Column(
//                           children: [
//                             Text(
//                               data?.bankName ?? '',
//                               style: context.textTheme.s14w500
//                                   .copyWith(color: AppColors.primary1C1C1C),
//                             ),
//                             const VerticalSpacing(16),
//                             Text(
//                               data?.accountName ?? '',
//                               style: context.textTheme.s14w400
//                                   .copyWith(color: AppColors.primary676767),
//                             ),
//                             const VerticalSpacing(16),
//                             Text(
//                               data?.accountNumber ?? '',
//                               style: context.textTheme.s20w600
//                                   .copyWith(color: AppColors.black),
//                             ),
//                           ],
//                         ),
//                       );
//                     })),
//             const VerticalSpacing(16),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
//               decoration: BoxDecoration(
//                   color: AppColors.primaryE1F5FF,
//                   borderRadius: BorderRadius.circular(8)),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                           height: 18,
//                           width: 18,
//                           child: Image.asset('assets/images/info.png')),
//                       const HorizontalSpacing(8),
//                       Text(
//                         'How to use bank transfer',
//                         style: context.textTheme.s12w600
//                             .copyWith(color: AppColors.black),
//                       )
//                     ],
//                   ),
//                   const VerticalSpacing(10),
//                   const Padding(
//                     padding: EdgeInsets.only(left: 25),
//                     child: Column(
//                       children: [
//                         BankInfoWidget(
//                           number: '1.',
//                           info:
//                               'Pay your desired amount into any of the accounts above',
//                         ),
//                         VerticalSpacing(10),
//                         BankInfoWidget(
//                           number: '2.',
//                           info:
//                               'After payment, it will automatically reflect in your wallet',
//                         ),
//                         VerticalSpacing(10),
//                         BankInfoWidget(
//                           number: '3.',
//                           info:
//                               'If you run into any payment issue please contact support',
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }

// class BankInfoWidget extends StatelessWidget {
//   const BankInfoWidget({super.key, required this.number, required this.info});
//   final String number;
//   final String info;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           number,
//           style: context.textTheme.s12w500.copyWith(
//             color: AppColors.primary676767,
//           ),
//         ),
//         const HorizontalSpacing(6),
//         Expanded(
//           child: Text(
//             info,
//             style: context.textTheme.s12w500.copyWith(
//               color: AppColors.primary676767,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// lib/presentation/features/fund_wallet/presentation/view/bank_transfer_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/data/data/local_data_source/local_storage_impl.dart';
import 'package:pmcsms/presentation/features/login/data/model/login_response.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class BankTransferView extends ConsumerStatefulWidget {
  const BankTransferView({super.key});
  static const String routeName = '/bankTransfer';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BankTransferViewState();
}

class _BankTransferViewState extends ConsumerState<BankTransferView> {
  LoginResponse? response;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getBanksLists();
    });
    super.initState();
  }

  getBanksLists() async {
    final loginResponse = await SecureStorage().getLoginResponse();
    setState(() {
      response = loginResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get the raw accounts list
    final rawBanksList = response?.data?.userManualAccount;

    // 2. Filter out explicit backend placeholder "Nil" values or empty records safely
    final banksList = rawBanksList?.where((account) {
      final name = account.bankName?.trim().toLowerCase();
      final number = account.accountNumber?.trim().toLowerCase();

      return name != null &&
          name != 'nil' &&
          name.isNotEmpty &&
          number != null &&
          number != 'nil' &&
          number.isNotEmpty;
    }).toList();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Bank Transfer',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. Conditional Layout: Fallback cleanly if no valid accounts exist
              if (banksList == null || banksList.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      "No manual bank funding accounts are available right now. Please contact support or use online card funding.",
                      style: context.textTheme.s14w400
                          .copyWith(color: AppColors.primary676767),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: banksList.length,
                  separatorBuilder: (_, __) => const VerticalSpacing(12),
                  itemBuilder: (_, index) {
                    final data = banksList[index];
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryF5F7F9,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            data.bankName ?? '',
                            style: context.textTheme.s14w500
                                .copyWith(color: AppColors.primary1C1C1C),
                          ),
                          const VerticalSpacing(8),
                          Text(
                            data.accountName ?? '',
                            style: context.textTheme.s14w400
                                .copyWith(color: AppColors.primary676767),
                            textAlign: TextAlign.center,
                          ),
                          const VerticalSpacing(12),
                          SelectableText(
                            data.accountNumber ?? '',
                            style: context.textTheme.s20w600
                                .copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const VerticalSpacing(24),

              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.primaryE1F5FF,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 18,
                          width: 18,
                          child: Image.asset('assets/images/info.png'),
                        ),
                        const HorizontalSpacing(8),
                        Text(
                          'How to use bank transfer',
                          style: context.textTheme.s12w600
                              .copyWith(color: AppColors.black),
                        )
                      ],
                    ),
                    const VerticalSpacing(14),
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Column(
                        children: [
                          BankInfoWidget(
                            number: '1.',
                            info:
                                'Pay your desired amount into any of the accounts above.',
                          ),
                          VerticalSpacing(10),
                          BankInfoWidget(
                            number: '2.',
                            info:
                                'After payment, it will automatically reflect in your wallet.',
                          ),
                          VerticalSpacing(10),
                          BankInfoWidget(
                            number: '3.',
                            info:
                                'If you run into any payment issue please contact support.',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BankInfoWidget extends StatelessWidget {
  const BankInfoWidget({super.key, required this.number, required this.info});
  final String number;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: context.textTheme.s12w500.copyWith(
            color: AppColors.primary676767,
          ),
        ),
        const HorizontalSpacing(6),
        Expanded(
          child: Text(
            info,
            style: context.textTheme.s12w500.copyWith(
              color: AppColors.primary676767,
            ),
          ),
        ),
      ],
    );
  }
}
