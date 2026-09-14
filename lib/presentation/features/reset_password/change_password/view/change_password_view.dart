import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/reset_password/change_password/data/model/change_password_request.dart';
import 'package:pmcsms/presentation/features/reset_password/change_password/data/notifier/change_password_notifier.dart';
import 'package:pmcsms/presentation/features/reset_password/presentation/widgets/validation_chip.dart';
import 'package:pmcsms/presentation/general_widgets/app_password_field.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// "Change password" for an already-logged-in user, using their current
/// password — distinct from ResetPasswordView, which is the OTP-based
/// forgot-password flow.
class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});
  static const String routeName = '/changePassword';

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final ValueNotifier<bool> _isChangePasswordEnabled = ValueNotifier(false);

  late TextEditingController _currentPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _currentPasswordController = TextEditingController()
      ..addListener(_validateInput);
    _passwordController = TextEditingController()..addListener(_validateInput);
    _confirmPasswordController = TextEditingController()
      ..addListener(_validateInput);
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateInput() {
    _isChangePasswordEnabled.value =
        _currentPasswordController.text.isNotEmpty &&
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
    final isLoading =
        ref.watch(changePasswordNotifier.select((v) => v.isLoading));

    return PageLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Change Password'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your current password and choose a new one',
                  style: context.textTheme.s12w400.copyWith(
                    color: AppColors.primary494949,
                  ),
                ),
                const VerticalSpacing(32),
                AppPasswordField(
                  label: 'Current Password',
                  controller: _currentPasswordController,
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
                        text: 'Min. 8 characters', isValid: hasMinLength),
                    ValidationChip(text: '1 uppercase', isValid: hasUpperCase),
                    ValidationChip(text: '1 lowercase', isValid: hasLowerCase),
                    ValidationChip(
                        text: '1 special character', isValid: hasSpecialChar),
                    ValidationChip(text: '1 number', isValid: hasNumber),
                  ],
                ),
                const VerticalSpacing(32),
                AppPasswordField(
                  label: 'Confirm New Password',
                  controller: _confirmPasswordController,
                ),
                const VerticalSpacing(50),
                ValueListenableBuilder(
                  valueListenable: _isChangePasswordEnabled,
                  builder: (context, enabled, _) {
                    return AppSendButton(
                      isEnabled: enabled,
                      onTap: _changePassword,
                      title: 'Change password',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    ref.read(changePasswordNotifier.notifier).changePassword(
          data: ChangePasswordRequest(
            currentPassword: _currentPasswordController.text.trim(),
            newPassword: _passwordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
          ),
          onError: (error) {
            // Surfaces "Incorrect current password supplied", etc.
            context.showError(message: error);
          },
          onSuccess: (message) {
            context.hideOverLay();
            context.showSuccess(message: message);
            Navigator.of(context).pop();
          },
        );
  }
}
