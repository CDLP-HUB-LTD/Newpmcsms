// lib/presentation/features/notifications/presentation/view/notifications_view.dart
import 'package:flutter/material.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';

/// Placeholder screen for notifications — no backend endpoint exists yet.
/// Once one does, replace the body with a real fetch (notifier +
/// repository, following the same pattern as e.g. GetAllDraftsNotifier)
/// and swap this empty state for a real list.
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});
  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 48,
                  color: AppColors.primary494949.withOpacity(0.4),
                ),
                const SizedBox(height: 12),
                Text(
                  'No notifications yet',
                  style: context.textTheme.s14w500
                      .copyWith(color: AppColors.primary494949),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
