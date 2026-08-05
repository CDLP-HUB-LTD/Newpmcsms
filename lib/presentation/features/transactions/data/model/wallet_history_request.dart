class WalletHistoryRequest {
  final String process;
  final String action;
  final int? start;
  final int? length;
  final String? processType;
  final String? status;
  final String? startDate;
  final String? endDate;

  WalletHistoryRequest({
    required this.process,
    required this.action,
    this.start,
    this.length,
    this.processType,
    this.status,
    this.startDate,
    this.endDate,
  });

  WalletHistoryRequest copyWith({
    String? process,
    String? action,
    int? start,
    int? length,
    String? processType,
    String? status,
    String? startDate,
    String? endDate,
  }) =>
      WalletHistoryRequest(
        process: process ?? this.process,
        action: action ?? this.action,
        start: start ?? this.start,
        length: length ?? this.length,
        processType: processType ?? this.processType,
        status: status ?? this.status,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  factory WalletHistoryRequest.fromJson(Map<String, dynamic> json) =>
      WalletHistoryRequest(
        process: json["process"],
        action: json["action"],
        start: json["start"],
        length: json["length"],
        processType: json["process_type"],
        status: json["status"],
        startDate: json["start_date"],
        endDate: json["end_date"],
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'process': process,
      'action': action,
    };
    if (start != null) map['start'] = start;
    if (length != null) map['length'] = length;
    if (processType != null) map['process_type'] = processType;
    if (status != null) map['status'] = status;
    if (startDate != null) map['start_date'] = startDate;
    if (endDate != null) map['end_date'] = endDate;
    return map;
  }
}
