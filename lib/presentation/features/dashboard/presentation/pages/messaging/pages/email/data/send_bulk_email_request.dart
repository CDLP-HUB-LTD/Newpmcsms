// lib/presentation/features/email/data/model/send_bulk_email_request.dart
class SendBulkEmailRequest {
  final String senderId;
  final String subject;
  final String message;
  final String recipients; // comma-separated emails

  const SendBulkEmailRequest({
    required this.senderId,
    required this.subject,
    required this.message,
    required this.recipients,
  });

  Map<String, dynamic> toJson() => {
        'process': 'pm_email',
        'action': 'send_bulk_email',
        'sender_id': senderId,
        'subject': subject,
        'message': message,
        'recipients': recipients,
      };
}

// lib/presentation/features/email/data/model/get_service_sender_id_request.dart
class GetServiceSenderIdRequest {
  final String service; // 'email' or 'sms'

  const GetServiceSenderIdRequest({required this.service});

  Map<String, dynamic> toJson() => {
        'process': 'pm_messaging',
        'action': 'get_service_sender_id',
        'service': service,
      };
}
