class PersonalizedSmsFailedRow {
  final String recipient;
  final String error;

  const PersonalizedSmsFailedRow(
      {required this.recipient, required this.error});

  factory PersonalizedSmsFailedRow.fromJson(Map<String, dynamic> json) {
    return PersonalizedSmsFailedRow(
      recipient: json['recipient']?.toString() ?? '',
      error: json['error']?.toString() ?? '',
    );
  }
}

class SubmitPersonalizedSmsResponse {
  final bool status;
  final String serverMessage;
  final int processed;
  final int failed;
  final List<PersonalizedSmsFailedRow> failedRows;

  const SubmitPersonalizedSmsResponse({
    required this.status,
    required this.serverMessage,
    required this.processed,
    required this.failed,
    required this.failedRows,
  });

  factory SubmitPersonalizedSmsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final rawFailedRows = dataMap['failed_rows'];

    return SubmitPersonalizedSmsResponse(
      status: json['status'] == true,
      serverMessage: json['server_message']?.toString() ?? '',
      processed: dataMap['processed'] is int ? dataMap['processed'] : 0,
      failed: dataMap['failed'] is int ? dataMap['failed'] : 0,
      failedRows: rawFailedRows is List
          ? rawFailedRows
              .whereType<Map<String, dynamic>>()
              .map(PersonalizedSmsFailedRow.fromJson)
              .toList()
          : [],
    );
  }
}
