class ResetPasswordRequest {
  final String process;
  final String action;
  final String otpCode;
  final String password;
  final String confirmPassword;

  const ResetPasswordRequest({
    this.process = 'pm_auth',
    this.action = 'change_password',
    required this.otpCode,
    required this.password,
    required this.confirmPassword,
  });

  /// Keys here must match the API exactly: `otp_code`, `password`,
  /// `confirm_password` — NOT `new_password`, which the endpoint rejects.
  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'otp_code': otpCode,
        'password': password,
        'confirm_password': confirmPassword,
      };
}
