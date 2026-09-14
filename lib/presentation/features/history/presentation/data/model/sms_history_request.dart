class SmsHistoryRequest {
  /// 'sms' | 'email' | 'voice_sms'
  final String service;

  /// 'all' | 'successful' | 'pending' | 'failed'
  final String status;

  /// Page number, 1-indexed (endpoint calls this `start`)
  final int start;

  /// Page size (endpoint calls this `length`)
  final int length;

  final String? search;

  const SmsHistoryRequest({
    this.service = 'sms',
    this.status = 'all',
    this.start = 1,
    this.length = 20,
    this.search,
  });

  SmsHistoryRequest copyWith({
    String? service,
    String? status,
    int? start,
    int? length,
    String? search,
  }) {
    return SmsHistoryRequest(
      service: service ?? this.service,
      status: status ?? this.status,
      start: start ?? this.start,
      length: length ?? this.length,
      search: search ?? this.search,
    );
  }

  Map<String, dynamic> toJson() => {
        'process': 'pm_sms',
        'action': 'get_service_history',
        'service': service,
        'status': status,
        'start': start,
        'length': length,
        if (search != null && search!.trim().isNotEmpty) 'search': search,
      };
}
