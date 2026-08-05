import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class PinVerificationView extends ConsumerStatefulWidget {
  const PinVerificationView({super.key});
  static const String routeName = '/pinVerification';

  @override
  ConsumerState<PinVerificationView> createState() =>
      _PinVerificationViewState();
}

class _PinVerificationViewState extends ConsumerState<PinVerificationView> {
  final TextEditingController _otpController = TextEditingController();
  int _start = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _start = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45.w,
      height: 50.h,
      textStyle: context.textTheme.s16w600,
      decoration: BoxDecoration(
        color: AppColors.primaryF5F7F9,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    return Scaffold(
      appBar: const CustomAppBar(title: 'Verification'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: context.textTheme.s12w400
                      .copyWith(color: AppColors.primary494949),
                  children: [
                    const TextSpan(text: 'We sent a 6-digit code to you at '),
                    TextSpan(
                      text: 'johndoe@gmail.com',
                      style: context.textTheme.s12w600,
                    ),
                    const TextSpan(text: '. Enter it below to continue'),
                  ],
                ),
              ),
              const VerticalSpacing(24),
              Pinput(
                controller: _otpController,
                length: 6,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const VerticalSpacing(24),
              CustomButton(
                text: 'Verify',
                backgroundColor: const Color(0xFF9EA3FF),
                onPressed: () {
                  // Navigate to Set New Pin screen
                },
              ),
              const VerticalSpacing(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't get code? ",
                    style:
                        context.textTheme.s12w400.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: _start == 0 ? _startTimer : null,
                    child: Text(
                      _start > 0
                          ? '00:${_start.toString().padLeft(2, '0')}'
                          : 'Resend',
                      style: context.textTheme.s12w600.copyWith(
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
