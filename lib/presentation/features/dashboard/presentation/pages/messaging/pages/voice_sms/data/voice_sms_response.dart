/// Shared response envelope returned by every `/pmcsms.php` call
/// (`pm_voicerobo`, `pm_messaging`, etc).
///
/// Example (failure):
/// ```json
/// {
///   "server_message": "Operation could not be completed, Try again later or contact admin for resolution.",
///   "status": false,
///   "data": [],
///   "data_result": [],
///   "error_data": [],
///   "text_status": "failed",
///   "error": null
/// }
/// ```
class PmcsmsResponse {
  const PmcsmsResponse({
    required this.serverMessage,
    required this.status,
    required this.data,
    required this.dataResult,
    required this.errorData,
    required this.textStatus,
    this.error,
  });

  final String serverMessage;
  final bool status;
  final List<dynamic> data;
  final List<dynamic> dataResult;
  final List<dynamic> errorData;
  final String textStatus;
  final dynamic error;

  factory PmcsmsResponse.fromJson(Map<String, dynamic> json) {
    return PmcsmsResponse(
      serverMessage: json['server_message']?.toString() ?? '',
      status: json['status'] == true,
      data: (json['data'] is List) ? json['data'] as List<dynamic> : const [],
      dataResult: (json['data_result'] is List)
          ? json['data_result'] as List<dynamic>
          : const [],
      errorData: (json['error_data'] is List)
          ? json['error_data'] as List<dynamic>
          : const [],
      textStatus: json['text_status']?.toString() ?? '',
      error: json['error'],
    );
  }

  bool get isSuccess => status && textStatus.toLowerCase() == 'success';

  /// Falls back to a generic message if the server didn't send one.
  String get displayMessage => serverMessage.isNotEmpty
      ? serverMessage
      : 'Operation could not be completed, Try again later or contact admin '
          'for resolution.';
}
