import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/presentation/features/balance/balance_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/contact/presentation/view/contact_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/home/home_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/presentation/view/messaging_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/more/presentation/view/more_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/widgets/bottom_nav.dart';
// ✅ Added the correct path reference for your KYC banner widget
import 'package:pmcsms/presentation/features/dashboard/presentation/widgets/kyc_banner_widget.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});
  static const String routeName = '/dashboard';

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Banners remain visible at the top, independent of tab switching
            const KycBannerWidget(),

            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: const [
                  HomeView(),
                  MessagesView(),
                  BalanceView(),
                  ContactView(),
                  MoreView(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
