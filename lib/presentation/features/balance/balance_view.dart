import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/balance/pages/cash_back/cashback_component.dart';
import 'package:pmcsms/presentation/features/balance/pages/email/email_component.dart';
import 'package:pmcsms/presentation/features/balance/pages/sms/sms_component.dart';
import 'package:pmcsms/presentation/features/balance/pages/voice_sms/voice_sms_component.dart';
import 'package:pmcsms/presentation/features/balance/pages/wallet/wallet_component.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';

class BalanceView extends ConsumerStatefulWidget {
  const BalanceView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BalanceViewState();
}

class _BalanceViewState extends ConsumerState<BalanceView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        leading: SizedBox.shrink(),
        title: 'Balances',
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 15, top: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(4)),
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                  labelColor: AppColors.white,
                  labelStyle: context.textTheme.s12w400,
                  tabs: const [
                    Text('Wallet'),
                    Text('Cash back'),
                    Text('Sms'),
                    // Text('Email'),
                    Text('Voice SMS'),
                  ]),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                WalletComponent(),
                CashbackComponent(),
                SmsComponent(),
                // EmailComponent(),
                VoiceSmsComponent()
              ],
            ),
          )
        ],
      )),
    );
  }
}
