// lib/presentation/features/senderid/views/delete_sender_id_request.dart
class DeleteSenderIdRequest {
  final String process;
  final String action;
  final String service;
  final String senderId;

  DeleteSenderIdRequest({
    this.process = 'pm_messaging',
    this.action = 'delete_sender_id',
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
