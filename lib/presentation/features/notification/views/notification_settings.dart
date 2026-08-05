import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class NotificationSettingView extends ConsumerStatefulWidget {
  const NotificationSettingView({super.key});
  static const String routeName = '/notification-settings';

  @override
  ConsumerState<NotificationSettingView> createState() =>
      _NotificationSettingViewState();
}

class _NotificationSettingViewState
    extends ConsumerState<NotificationSettingView> {
  // Push Notification Toggles
  bool _pushTransactions = true;
  bool _pushNews = true;
  bool _pushOffers = true;

  // Email Notification Toggles
  bool _emailTransactions = true;
  bool _emailNews = true;
  bool _emailOffers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Notification Setting'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('PUSH NOTIFICATION'),
              const VerticalSpacing(12),
              _buildSettingTile(
                title: 'Transactions',
                subtitle: 'Get notified on your transaction activities',
                value: _pushTransactions,
                onChanged: (val) => setState(() => _pushTransactions = val),
              ),
              _buildSettingTile(
                title: 'News',
                subtitle: 'Get notified on new features and promos',
                value: _pushNews,
                onChanged: (val) => setState(() => _pushNews = val),
              ),
              _buildSettingTile(
                title: 'Offers and discounts',
                subtitle: 'Get notified on new features and promos',
                value: _pushOffers,
                onChanged: (val) => setState(() => _pushOffers = val),
              ),
              const VerticalSpacing(24),
              _buildSectionHeader('EMAIL NOTIFICATION'),
              const VerticalSpacing(12),
              _buildSettingTile(
                title: 'Transactions',
                subtitle: 'Get notified on your transaction activities',
                value: _emailTransactions,
                onChanged: (val) => setState(() => _emailTransactions = val),
              ),
              _buildSettingTile(
                title: 'News',
                subtitle: 'Get notified on new features and promos',
                value: _emailNews,
                onChanged: (val) => setState(() => _emailNews = val),
              ),
              _buildSettingTile(
                title: 'Offers and discounts',
                subtitle: 'Get notified on new features and promos',
                value: _emailOffers,
                onChanged: (val) => setState(() => _emailOffers = val),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: context.textTheme.s10w500.copyWith(
        color: Colors.grey,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primaryE6E6E6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.s14w500,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: context.textTheme.s10w400.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
