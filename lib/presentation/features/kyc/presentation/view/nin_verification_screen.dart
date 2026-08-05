// lib/presentation/features/kyc/presentation/view/nin_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class NinVerificationScreen extends StatefulWidget {
  const NinVerificationScreen({super.key});
  static const String routeName = '/nin-verification';

  @override
  State<NinVerificationScreen> createState() => _NinVerificationScreenState();
}

class _NinVerificationScreenState extends State<NinVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ninController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _ninController.dispose();
    super.dispose();
  }

  void _submitNin() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Connect to your Riverpod Notifier action flow here
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify NIN'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'National Identity Number',
                  style: context.textTheme.s18w600
                      .copyWith(color: AppColors.black),
                ),
                const VerticalSpacing(8),
                Text(
                  'Dial *346# from your NIMC linked ecosystem phone line to check your 11-digit processing key.',
                  style: context.textTheme.s12w400
                      .copyWith(color: Colors.grey[600]),
                ),
                const VerticalSpacing(24),
                TextFormField(
                  controller: _ninController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  style: context.textTheme.s16w500.copyWith(letterSpacing: 2),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter 11-digit NIN',
                    counterText: '',
                    hintStyle: context.textTheme.s14w400
                        .copyWith(color: Colors.grey[400], letterSpacing: 0),
                    prefixIcon:
                        const Icon(Icons.fingerprint, color: Colors.grey),
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
                      return 'Please enter your NIN';
                    }
                    if (value.length != 11) {
                      return 'NIN must be exactly 11 digits';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitNin,
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
