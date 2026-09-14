// lib/presentation/features/dashboard/presentation/pages/messaging/data/model/delete_scheduled_message_request.dart
class DeleteScheduledMessageRequest {
  final String process;
  final String action;
  final int scheduleId;

  DeleteScheduledMessageRequest({
    this.process = 'pm_sms',
    this.action = 'delete_scheduled_message',
    required this.scheduleId,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'schedule_id': scheduleId,
      };
}
