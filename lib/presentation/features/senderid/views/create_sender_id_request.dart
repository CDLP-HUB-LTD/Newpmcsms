// lib/presentation/features/senderid/views/create_sender_id_request.dart
class CreateSenderIdRequest {
  final String process;
  final String action;
  final String service;
  final String senderId;

  CreateSenderIdRequest({
    this.process = 'pm_messaging',
    this.action = 'create_sender_id',
    required this.service,
    required this.senderId,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'service': service,
        'sender_id': senderId,
      };
}
