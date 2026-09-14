class ChangePasswordRequest {
  final String process;
  final String action;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordRequest({
    this.process = 'pm_profile',
    this.action = 'change_password',
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
}
