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
