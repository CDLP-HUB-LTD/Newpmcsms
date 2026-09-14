// lib/presentation/features/dashboard/presentation/pages/messaging/data/model/create_schedule_sms_request.dart
class CreateScheduleSmsRequest {
  final String process;
  final String action;
  final String senderId;
  final String message;
  final String recipient;
  final String scheduleDate;

  CreateScheduleSmsRequest({
    this.process = 'pm_sms',
    this.action = 'create_schedule_sms',
    required this.senderId,
    required this.message,
    required this.recipient,
    required this.scheduleDate,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'sender_id': senderId,
        'message': message,
        'recipient': recipient,
        'schedule_date': scheduleDate,
      };
}
