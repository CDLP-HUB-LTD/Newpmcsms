/// Request payload for `pm_voicerobo` / `send_voice_sms`.
///
/// Example wire format:
/// ```json
/// {
///   "process": "pm_voicerobo",
///   "action": "send_voice_sms",
///   "from": "PMCSMS",
///   "recipient": "08012345678",
///   "message": "This is a voice message",
///   "schedule_date": ""
/// }
/// ```
class SendVoiceSmsRequest {
  const SendVoiceSmsRequest({
    required this.from,
    required this.recipient,
    required this.message,
    this.scheduleDate = '',
    this.process = 'pm_voicerobo',
    this.action = 'send_voice_sms',
  });

  final String process;
  final String action;

  /// The sender ID, e.g. "PMCSMS".
  final String from;

  /// Comma-separated recipient phone numbers, matching the sample payload
  /// (single or multiple numbers separated by commas).
  final String recipient;

  /// Text content for the voice message.
  ///
  /// NOTE: the sample payload only supports a plain string here. If the
  /// backend expects an actual recorded/uploaded audio file, that likely
  /// needs a separate upload step (e.g. multipart upload returning a
  /// message ID/URL) before this call — that endpoint wasn't provided.
  final String message;

  /// Empty string ("") for "send now"; otherwise a formatted schedule
  /// date/time string, e.g. "2026-08-15 14:30:00".
  final String scheduleDate;

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'from': from,
        'recipient': recipient,
        'message': message,
        'schedule_date': scheduleDate,
      };
}
