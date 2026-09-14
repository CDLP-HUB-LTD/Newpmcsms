import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/reset_password/data/model/reset_password_request.dart';
import 'package:pmcsms/presentation/features/reset_password/presentation/notifier/reset_password_notifier.dart';
import 'package:pmcsms/presentation/features/reset_password/presentation/view/reset_password_success_view.dart';
import 'package:pmcsms/presentation/features/reset_password/presentation/widgets/validation_chip.dart';
import 'package:pmcsms/presentation/general_widgets/app_password_field.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  /// The OTP the user just verified/received for the password-reset flow.
  /// This has to come from wherever that OTP step happens (e.g. an
  /// OTP-entry screen or the forgot-password flow) — it can no longer be
  /// hardcoded, since the API validates it and rejects unknown codes.
  const ResetPasswordView({super.key, required this.otpCode});

  static const String routeName = '/resetPassword';

  final String otpCode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final ValueNotifier<bool> _isResetPasswordEnabled = ValueNotifier(false);

  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _confirmPasswordController = TextEditingController()
      ..addListener(_validateInput);

    _passwordController = TextEditingController()..addListener(_validateInput);
    super.initState();
  }

  @override
  void dispose() {
    _confirmPasswordController.dispose();

    _passwordController.dispose();
    super.dispose();
  }

  void _validateInput() {
    _isResetPasswordEnabled.value =
        _confirmPasswordController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty &&
            isValid;
  }

  bool get hasMinLength => _passwordController.text.length >= 8;
  bool get hasUpperCase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get hasLowerCase => _passwordController.text.contains(RegExp(r'[a-z]'));
  bool get hasSpecialChar =>
      _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool get hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get passwordsMatch =>
      _passwordController.text == _confirmPasswordController.text;

  bool get isValid =>
      hasMinLength &&
      hasUpperCase &&
      hasLowerCase &&
      hasSpecialChar &&
      hasNumber &&
      passwordsMatch &&
      _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        resetPasswordNotifier.select((v) => v.resetPasswordState.isLoading));
    return PageLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Reset Password',
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Almost done. Set your new password to proceed',
                style: context.textTheme.s12w400.copyWith(
                  color: AppColors.primary494949,
                ),
              ),
              const VerticalSpacing(32),
              AppPasswordField(
                onChange: (_) => setState(() {}),
                label: 'New Password',
                controller: _passwordController,
              ),
              const VerticalSpacing(12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ValidationChip(
                    text: 'Min. 8 characters',
                    isValid: hasMinLength,
                  ),
                  ValidationChip(
                    text: '1 uppercase',
                    isValid: hasUpperCase,
                  ),
                  ValidationChip(
                    text: '1 lowercase',
                    isValid: hasLowerCase,
                  ),
                  ValidationChip(
                    text: '1 special character',
                    isValid: hasSpecialChar,
                  ),
                  ValidationChip(
                    text: '1 number',
                    isValid: hasNumber,
                  ),
                ],
              ),
              const VerticalSpacing(32),
              AppPasswordField(
                label: 'Confirm new Password',
                controller: _confirmPasswordController,
              ),
              const VerticalSpacing(50),
              ValueListenableBuilder(
                  valueListenable: _isResetPasswordEnabled,
                  builder: (context, re, c) {
                    return AppSendButton(
                        isEnabled: re,
                        onTap: () {
                          _resetPassword();
                        },
                        title: 'Reset password');
                  }),
            ],
          ),
        )),
      ),
    );
  }

  void _resetPassword() {
    ref.read(resetPasswordNotifier.notifier).resetPassword(
          data: ResetPasswordRequest(
              otpCode: widget.otpCode,
              password: _passwordController.text.trim(),
              confirmPassword: _confirmPasswordController.text.trim()),
          onError: (error) {
            // Surfaces the server's own message, e.g.
            // "OTP Code provided does not exist"
            context.showError(message: error);
          },
          onSuccess: (message) {
            context.hideOverLay();
            context.showSuccess(message: message);

            context.pushReplacementNamed(ResetPasswordSuccessView.routeName);
          },
        );
  }
}
