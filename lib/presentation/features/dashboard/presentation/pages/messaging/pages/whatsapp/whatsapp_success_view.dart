import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class WhatsappSuccessView extends StatelessWidget {
  const WhatsappSuccessView({super.key});
  static const String routeName = '/whatsapp-success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              CircleAvatar(
                radius: 36.r,
                backgroundColor: Colors.green.shade50,
                child: Icon(Icons.check, size: 36.r, color: Colors.green),
              ),
              const VerticalSpacing(20),
              Text('Success!', style: context.textTheme.s20w600),
              const VerticalSpacing(8),
              Text(
                'Message sent successfully',
                style: context.textTheme.s12w400.copyWith(color: Colors.grey),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue',
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
              const VerticalSpacing(20),
            ],
          ),
        ),
      ),
    );
  }
}
