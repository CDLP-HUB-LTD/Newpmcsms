import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/transaction_pin/data/set_transaction_pin_request.dart';

import 'package:pmcsms/presentation/features/transaction_pin/presentation/notifier/set_transaction_pin_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/page_loader.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class SetTransactionPin extends ConsumerStatefulWidget {
  const SetTransactionPin({super.key});
  static const String routeName = '/setTransactionPin';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetTransactionPinState();
}

class _SetTransactionPinState extends ConsumerState<SetTransactionPin> {
  final ValueNotifier<bool> _isLoginEnabled = ValueNotifier(false);

  late TextEditingController _setPinController;

  late TextEditingController _confirmPinController;

  @override
  void initState() {
    _setPinController = TextEditingController()..addListener(_validateInput);

    _confirmPinController = TextEditingController()
      ..addListener(_validateInput);
    super.initState();
  }

  @override
  void dispose() {
    _setPinController.dispose();

    _confirmPinController.dispose();
    super.dispose();
  }

  void _validateInput() {
    _isLoginEnabled.value = _setPinController.text.isNotEmpty &&
        _confirmPinController.text.isNotEmpty &&
        _setPinController.text == _confirmPinController.text &&
        _setPinController.text.length == 6 &&
        _confirmPinController.text.length == 6;
  }

  bool isObscureNewPin = true;
  bool isObscureConfirmPin = true;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(transactionPinNotifier.select((v) => v.isLoading));
    return Scaffold(
      // ignore: prefer_const_constructors
      appBar: CustomAppBar(
        title: 'Set New Pin',
      ),
      body: PageLoader(
        isLoading: isLoading,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Use secure numbers for your pin, pin must not contain numbers that can be repeated',
                style: context.textTheme.s12w400.copyWith(
                  color: AppColors.primary494949,
                ),
              ),
              const VerticalSpacing(24),
              Row(
                children: [
                  Text(
                    'New pin',
                    style: context.textTheme.s14w500.copyWith(
                      color: AppColors.primary494949,
                    ),
                  ),
                  const HorizontalSpacing(12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscureNewPin = !isObscureNewPin;
                      });
                    },
                    child: Icon(
                      isObscureNewPin
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                  )
                ],
              ),
              const VerticalSpacing(12),
              Pinput(
                obscureText: isObscureNewPin,
                controller: _setPinController,
                length: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const VerticalSpacing(24),
              Row(
                children: [
                  Text(
                    'Confirm new pin',
                    style: context.textTheme.s14w500.copyWith(
                      color: AppColors.primary494949,
                    ),
                  ),
                  const HorizontalSpacing(12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscureConfirmPin = !isObscureConfirmPin;
                      });
                    },
                    child: Icon(
                      isObscureConfirmPin
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                  )
                ],
              ),
              const VerticalSpacing(12),
              Pinput(
                obscureText: isObscureConfirmPin,
                controller: _confirmPinController,
                length: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const VerticalSpacing(40),
              ValueListenableBuilder(
                  valueListenable: _isLoginEnabled,
                  builder: (context, re, c) {
                    return AppSendButton(
                        isEnabled: re,
                        onTap: () {
                          setTransactionPin();
                        },
                        title: 'Set new pin');
                  }),
            ],
          ),
        )),
      ),
    );
  }

  void setTransactionPin() {
    final data = TransactionPinRequest.set(
      newPin: _setPinController.text.trim(),
      confirmNewPin: _confirmPinController.text.trim(),
    );
    ref.read(transactionPinNotifier.notifier).submit(
        data: data,
        onError: (error) {
          context.showError(message: error);
        },
        onSuccess: (message) {
          context.showSuccess(message: message);
          Navigator.of(context).pop();
        });
  }
}
