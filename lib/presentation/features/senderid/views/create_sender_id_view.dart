import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/presentation/features/senderid/views/otp_verification_view.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class CreateSenderIdView extends ConsumerStatefulWidget {
  const CreateSenderIdView({super.key});
  static const String routeName = '/createSenderId';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateSenderIdViewState();
}

class _CreateSenderIdViewState extends ConsumerState<CreateSenderIdView> {
  String? _selectedService;
  final _senderIdController = TextEditingController();

  @override
  void dispose() {
    _senderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Sender ID'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Service', style: context.textTheme.s12w400),
              const VerticalSpacing(6),
              DropdownButtonFormField<String>(
                value: _selectedService,
                hint: const Text('Select a service'),
                items: const [
                  DropdownMenuItem(value: 'SMS', child: Text('SMS')),
                  DropdownMenuItem(value: 'Email', child: Text('Email')),
                  DropdownMenuItem(
                      value: 'Voice SMS', child: Text('Voice SMS')),
                ],
                onChanged: (val) => setState(() => _selectedService = val),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primaryF5F7F9,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const VerticalSpacing(16),
              Text('Sender ID', style: context.textTheme.s12w400),
              const VerticalSpacing(6),
              TextField(
                controller: _senderIdController,
                decoration: InputDecoration(
                  hintText: 'Eg. PMCSMS',
                  filled: true,
                  fillColor: AppColors.primaryF5F7F9,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const VerticalSpacing(8),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                  const HorizontalSpacing(4),
                  Text(
                    'Please use alphanumeric combinations.',
                    style: context.textTheme.s12w400.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size.fromHeight(48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  if (_selectedService == 'Email' ||
                      _selectedService == 'Voice SMS') {
                    context.pushNamed(OtpVerificationView.routeName);
                  } else {
                    _showUnderReviewModal(context);
                  }
                },
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnderReviewModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_top_rounded,
                size: 48, color: Colors.amber[600]),
            const VerticalSpacing(16),
            Text('Under Review', style: context.textTheme.s18w500),
            const VerticalSpacing(8),
            Text(
              'The ID is under review by admin. Approval takes between 24 to 48 hours. You will be able to use it once it\'s been approved.',
              textAlign: TextAlign.center,
              style: context.textTheme.s12w400.copyWith(color: Colors.grey),
            ),
            const VerticalSpacing(20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: Size.fromHeight(44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close sheet
                Navigator.pop(context); // Return to list
              },
              child:
                  const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
