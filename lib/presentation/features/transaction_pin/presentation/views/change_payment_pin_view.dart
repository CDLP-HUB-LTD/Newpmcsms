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

class ChangePaymentPinView extends ConsumerStatefulWidget {
  const ChangePaymentPinView({super.key});
  static const String routeName = '/changePaymentPin';

  @override
  ConsumerState<ChangePaymentPinView> createState() =>
      _ChangePaymentPinViewState();
}

class _ChangePaymentPinViewState extends ConsumerState<ChangePaymentPinView> {
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  late TextEditingController _oldPinController;
  late TextEditingController _newPinController;
  late TextEditingController _confirmPinController;

  bool _isObscureOldPin = true;
  bool _isObscureNewPin = true;
  bool _isObscureConfirmPin = true;

  @override
  void initState() {
    super.initState();
    _oldPinController = TextEditingController()..addListener(_validateInput);
    _newPinController = TextEditingController()..addListener(_validateInput);
    _confirmPinController = TextEditingController()
      ..addListener(_validateInput);
  }

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _validateInput() {
    _isButtonEnabled.value = _oldPinController.text.length == 4 &&
        _newPinController.text.length == 4 &&
        _confirmPinController.text.length == 4 &&
        _newPinController.text == _confirmPinController.text;
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.h,
      textStyle: context.textTheme.s16w600,
      decoration: BoxDecoration(
        color: AppColors.primaryF5F7F9,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    return Scaffold(
      appBar: const CustomAppBar(title: 'Change Payment Pin'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Use secure numbers for your pin, pin must not contain numbers that can be repeated',
                style: context.textTheme.s12w400
                    .copyWith(color: AppColors.primary494949),
              ),
              const VerticalSpacing(20),

              // Old Pin
              _buildPinLabel('Old pin', _isObscureOldPin, () {
                setState(() => _isObscureOldPin = !_isObscureOldPin);
              }),
              const VerticalSpacing(10),
              Pinput(
                controller: _oldPinController,
                length: 4,
                obscureText: _isObscureOldPin,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const VerticalSpacing(20),

              // New Pin
              _buildPinLabel('New pin', _isObscureNewPin, () {
                setState(() => _isObscureNewPin = !_isObscureNewPin);
              }),
              const VerticalSpacing(10),
              Pinput(
                controller: _newPinController,
                length: 4,
                obscureText: _isObscureNewPin,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const VerticalSpacing(20),

              // Confirm New Pin
              _buildPinLabel('Confirm new pin', _isObscureConfirmPin, () {
                setState(() => _isObscureConfirmPin = !_isObscureConfirmPin);
              }),
              const VerticalSpacing(10),
              Pinput(
                controller: _confirmPinController,
                length: 4,
                obscureText: _isObscureConfirmPin,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const VerticalSpacing(16),

              // Forgot Pin
              GestureDetector(
                onTap: () {
                  // Navigate to Forgot Pin Request View
                },
                child: Text(
                  'Forgot pin?',
                  style: context.textTheme.s12w500
                      .copyWith(color: Colors.amber.shade800),
                ),
              ),
              const VerticalSpacing(32),

              ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, _) {
                  return CustomButton(
                    text: 'Set new pin',
                    backgroundColor: isEnabled
                        ? const Color(0xFF9EA3FF)
                        : const Color(0xFFC4C7FF),
                    onPressed: isEnabled ? () {} : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinLabel(String label, bool isObscured, VoidCallback onToggle) {
    return Row(
      children: [
        Text(
          label,
          style: context.textTheme.s14w500
              .copyWith(color: AppColors.primary494949),
        ),
        const HorizontalSpacing(8),
        GestureDetector(
          onTap: onToggle,
          child: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 18.r,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
