// lib/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/update_scheduled_message_request.dart
class UpdateScheduledMessageRequest {
  final String process;
  final String action;

  final int scheduleId;
  final String senderId; // Add this line
  final String message;
  final String scheduleDate;

  UpdateScheduledMessageRequest({
    this.process = 'pm_sms',
    this.action = 'update_scheduled_message',
    required this.scheduleId,
    required this.senderId, // Add this line
    required this.message,
    required this.scheduleDate,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'schedule_id': scheduleId,
        'senderid': senderId,
        'message': message,
        'schedule_date': scheduleDate,
      };
}
