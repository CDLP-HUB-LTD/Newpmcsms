class PersonalizedSmsRecord {
  final String phone;
  final String message;

  const PersonalizedSmsRecord({required this.phone, required this.message});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'message': message,
      };
}

class SubmitPersonalizedSmsRequest {
  final String process;
  final String action;
  final String senderId; // top-level, unlike autocompose which is per-record
  final int gatewayId;
  final List<PersonalizedSmsRecord> records;

  const SubmitPersonalizedSmsRequest({
    this.process = 'pm_sms',
    this.action = 'submit_personalized_sms',
    required this.senderId,
    required this.gatewayId,
    required this.records,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'sender_id': senderId,
        'gateway_id': gatewayId,
        'records': records.map((r) => r.toJson()).toList(),
      };
}
