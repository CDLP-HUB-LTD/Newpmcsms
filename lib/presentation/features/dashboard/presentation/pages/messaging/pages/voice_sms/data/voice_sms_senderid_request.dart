/// Request payload for `pm_messaging` / `get_service_sender_id`.
///
/// Example wire format:
/// ```json
/// {
///   "process": "pm_messaging",
///   "action": "get_service_sender_id",
///   "service": "sms"
/// }
/// ```
class GetServiceSenderIdRequest {
  const GetServiceSenderIdRequest({
    this.process = 'pm_messaging',
    this.action = 'get_service_sender_id',
    this.service = 'sms',
  });

  final String process;
  final String action;
  final String service;

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'service': service,
      };
}
