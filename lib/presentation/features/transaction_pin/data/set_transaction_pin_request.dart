class TransactionPinRequest {
  final String process;
  final String action; // 'set_transact_pin' | 'update_transact_pin'
  final String currentPin;
  final String newPin;
  final String confirmNewPin;

  const TransactionPinRequest({
    this.process = 'pm_profile',
    required this.action,
    required this.currentPin,
    required this.newPin,
    required this.confirmNewPin,
  });

  /// First-time pin creation — there's no existing pin to verify, so
  /// `current_pin` is a fixed placeholder rather than user input.
  factory TransactionPinRequest.set({
    required String newPin,
    required String confirmNewPin,
  }) =>
      TransactionPinRequest(
        action: 'set_transact_pin',
        currentPin: '000000',
        newPin: newPin,
        confirmNewPin: confirmNewPin,
      );

  /// Changing an existing pin — `currentPin` must be the pin the user
  /// actually typed in, since the server verifies it.
  factory TransactionPinRequest.update({
    required String currentPin,
    required String newPin,
    required String confirmNewPin,
  }) =>
      TransactionPinRequest(
        action: 'update_transact_pin',
        currentPin: currentPin,
        newPin: newPin,
        confirmNewPin: confirmNewPin,
      );

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'current_pin': currentPin,
        'new_pin': newPin,
        'confirm_new_pin': confirmNewPin,
      };
}
