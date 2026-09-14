class ViewSmsRequest {
  final int smsId;

  const ViewSmsRequest({required this.smsId});

  Map<String, dynamic> toJson() => {
        'process': 'pm_sms',
        'action': 'view_sms',
        'sms_id': smsId,
      };
}
