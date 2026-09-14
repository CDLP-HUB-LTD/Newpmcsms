// lib/presentation/features/sms/data/model/send_sms_request.dart
class SendSmsRequest {
  final String senderId;
  final String message;
  final String recipients;
  final int gatewayId; // ✅ required — no default
  final String processType;

  SendSmsRequest({
    required this.senderId,
    required this.message,
    required this.recipients,
    required this.gatewayId, // ✅ caller must supply a real ID
    this.processType = 'send',
  });

  Map<String, dynamic> toJson() => {
        "process": "pm_sms",
        "action": "send_bulk_sms",
        "sender_id": senderId,
        "message": message,
        "recipients": recipients,
        "gateway_id": gatewayId,
        "process_type": processType,
      };
}

class AutocomposeRecord {
  const AutocomposeRecord({
    required this.senderId,
    required this.phone,
    required this.message,
  });

  final String senderId;
  final String phone;
  final String message;

  Map<String, dynamic> toJson() => {
        'sender_id': senderId,
        'phone': phone,
        'message': message,
      };
}

class SendAutocomposeSmsRequest {
  const SendAutocomposeSmsRequest({
    required this.gatewayId,
    required this.records,
  });

  final int gatewayId;
  final List<AutocomposeRecord> records;

  Map<String, dynamic> toJson() => {
        'process': 'pm_sms',
        'action': 'submit_autocompose_sms',
        'gateway_id': gatewayId,
        'records': records.map((r) => r.toJson()).toList(),
      };
}

class SmsRecord {
  const SmsRecord({required this.phone, required this.message});

  final String phone;
  final String message;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'message': message,
      };
}
