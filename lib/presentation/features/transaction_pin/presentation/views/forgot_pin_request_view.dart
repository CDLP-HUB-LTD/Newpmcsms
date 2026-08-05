import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_text_field.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class ForgotPinRequestView extends ConsumerStatefulWidget {
  const ForgotPinRequestView({super.key});
  static const String routeName = '/forgotPinRequest';

  @override
  ConsumerState<ForgotPinRequestView> createState() =>
      _ForgotPinRequestViewState();
}

class _ForgotPinRequestViewState extends ConsumerState<ForgotPinRequestView> {
  int _selectedTabIndex = 0; // 0 for Phone number, 1 for Email Address
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Change Payment Pin'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Toggle Tab
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedTabIndex = 0;
                          _inputController.clear();
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: _selectedTabIndex == 0
                                ? [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 2.r)
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Phone number',
                            style: context.textTheme.s12w500.copyWith(
                              color: _selectedTabIndex == 0
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedTabIndex = 1;
                          _inputController.clear();
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: _selectedTabIndex == 1
                                ? [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 2.r)
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Email Address',
                            style: context.textTheme.s12w500.copyWith(
                              color: _selectedTabIndex == 1
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpacing(24),
              Text(
                _selectedTabIndex == 0
                    ? 'Please enter a valid number below'
                    : 'Please enter a valid email address below',
                style: context.textTheme.s12w400
                    .copyWith(color: AppColors.primary494949),
              ),
              const VerticalSpacing(12),
              CustomTextField(
                controller: _inputController,
                hintText: _selectedTabIndex == 0
                    ? 'E.g 08169784022'
                    : 'E.g johndoe@gmail.com',
              ),
              const VerticalSpacing(24),
              CustomButton(
                text: 'Proceed',
                backgroundColor: const Color(0xFF9EA3FF),
                onPressed: () {
                  // Navigate to Verification View
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
