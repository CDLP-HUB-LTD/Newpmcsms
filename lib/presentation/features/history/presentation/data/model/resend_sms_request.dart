class ResendSmsRequest {
  final int smsId;

  const ResendSmsRequest({required this.smsId});

  Map<String, dynamic> toJson() => {
        'process': 'pm_sms',
        'action': 'resend_sms',
        'sms_id': smsId,
      };
}
