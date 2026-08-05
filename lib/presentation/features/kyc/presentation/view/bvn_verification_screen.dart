// lib/presentation/features/kyc/presentation/view/bvn_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class BvnVerificationScreen extends StatefulWidget {
  const BvnVerificationScreen({super.key});
  static const String routeName = '/bvn-verification';

  @override
  State<BvnVerificationScreen> createState() => _BvnVerificationScreenState();
}

class _BvnVerificationScreenState extends State<BvnVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bvnController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _bvnController.dispose();
    super.dispose();
  }

  void _submitBvn() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Connect to your Riverpod Notifier action flow here
    // e.g., ref.read(kycSubmitNotifierProvider.notifier).verifyBvn(...)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context); // Return to parent profile view
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify BVN'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bank Verification Number',
                  style: context.textTheme.s18w600
                      .copyWith(color: AppColors.black),
                ),
                const VerticalSpacing(8),
                Text(
                  'Dial *565*0# from your registered mobile lines to retrieve your 11-digit BVN string layout profile.',
                  style: context.textTheme.s12w400
                      .copyWith(color: Colors.grey[600]),
                ),
                const VerticalSpacing(24),
                TextFormField(
                  controller: _bvnController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  obscureText: true, // Secure entry presentation
                  style: context.textTheme.s16w500.copyWith(letterSpacing: 2),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter 11-digit BVN',
                    counterText: '',
                    hintStyle: context.textTheme.s14w400
                        .copyWith(color: Colors.grey[400], letterSpacing: 0),
                    prefixIcon: const Icon(Icons.security, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          const BorderSide(color: AppColors.primaryE6E6E6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          const BorderSide(color: AppColors.primaryF9BC1F),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your BVN';
                    }
                    if (value.length != 11) {
                      return 'BVN must be exactly 11 digits';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitBvn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryF9BC1F,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Verify Number',
                            style: context.textTheme.s14w600
                                .copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
