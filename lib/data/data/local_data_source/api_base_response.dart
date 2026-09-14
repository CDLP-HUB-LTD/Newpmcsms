// lib/data/data/models/api_base_response.dart
class ApiBaseResponse {
  final String? serverMessage;
  final bool status;
  final List<dynamic> data;
  final List<dynamic> dataResult;
  final List<dynamic> errorData;
  final String textStatus;
  final String? error;

  const ApiBaseResponse({
    this.serverMessage,
    required this.status,
    this.data = const [],
    this.dataResult = const [],
    this.errorData = const [],
    this.textStatus = '',
    this.error,
  });

  factory ApiBaseResponse.fromJson(Map<String, dynamic> json) {
    return ApiBaseResponse(
      serverMessage: json['server_message'] as String?,
      status: json['status'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?) ?? const [],
      dataResult: (json['data_result'] as List<dynamic>?) ?? const [],
      errorData: (json['error_data'] as List<dynamic>?) ?? const [],
      textStatus: json['text_status'] as String? ?? '',
      error: json['error'] as String?,
    );
  }
}
