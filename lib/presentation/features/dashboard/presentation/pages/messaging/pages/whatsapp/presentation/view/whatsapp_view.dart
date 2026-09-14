import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/whatsapp/presentation/view/whatsapp_msg_text_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/whatsapp/presentation/view/whatsapp_msg_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/whatsapp/whatsapp_report_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/whatsapp/whatsapp_template_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_text_field.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class WhatsappView extends ConsumerStatefulWidget {
  const WhatsappView({super.key});
  static const String routeName = '/whatsapp';

  @override
  ConsumerState<WhatsappView> createState() => _WhatsappViewState();
}

class _WhatsappViewState extends ConsumerState<WhatsappView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Whatsapp'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: Icons.chat_outlined,
                title: 'Test Transactional Whatsapp MSG',
                onTap: () =>
                    Navigator.pushNamed(context, WhatsappMsgTestView.routeName),
              ),
              const VerticalSpacing(12),
              _buildMenuItem(
                context,
                icon: Icons.chat_bubble_outline,
                title: 'Transactional Whatsapp MSG',
                onTap: () =>
                    Navigator.pushNamed(context, WhatsappMsgView.routeName),
              ),
              const VerticalSpacing(12),
              _buildMenuItem(
                context,
                icon: Icons.receipt_long_outlined,
                title: 'Reports',
                onTap: () =>
                    Navigator.pushNamed(context, WhatsappReportsView.routeName),
              ),
              const VerticalSpacing(12),
              _buildMenuItem(
                context,
                icon: Icons.dashboard_customize_outlined,
                title: 'Whatsapp Template',
                onTap: () => Navigator.pushNamed(
                    context, WhatsappTemplateView.routeName),
              ),
              const VerticalSpacing(12),
              _buildMenuItem(
                context,
                icon: Icons.verified_user_outlined,
                title: 'Approved Whatsapp Number',
                onTap: () => _showApprovedNumberDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primaryE6E6E6),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14.r,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: Icon(icon, size: 16.r, color: AppColors.primaryColor),
            ),
            const HorizontalSpacing(12),
            Expanded(
              child: Text(
                title,
                style: context.textTheme.s14w500,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showApprovedNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _SendNumberApprovalDialog(),
    );
  }
}

// ── Approval Request Dialog ──────────────────────────────────────────────────

class _SendNumberApprovalDialog extends StatelessWidget {
  const _SendNumberApprovalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Send Number Approval Request',
              style: context.textTheme.s14w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Username',
              hintText: 'Enter username',
            ),
            VerticalSpacing(12),
            CustomTextField(
              label: 'Whatsapp Number',
              hintText: 'Enter whatsapp number',
            ),
            VerticalSpacing(12),
            CustomTextField(
              label: 'Whatsapp name',
              hintText: 'Enter whatsapp name',
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryE6E6E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const HorizontalSpacing(12),
            Expanded(
              child: CustomButton(
                text: 'Save',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
