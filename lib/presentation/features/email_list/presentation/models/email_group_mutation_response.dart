// lib/presentation/features/email_list/data/model/email_group_mutation_response.dart
/// Shared response shape for add/edit/delete email group calls.
class EmailGroupMutationResponse {
  final String? serverMessage;
  final bool? status;
  final List<dynamic>? data;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  EmailGroupMutationResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory EmailGroupMutationResponse.fromJson(Map<String, dynamic> json) =>
      EmailGroupMutationResponse(
        serverMessage: json['server_message'],
        status: json['status'],
        data: json['data'] == null ? [] : List<dynamic>.from(json['data']),
        dataResult: json['data_result'] == null
            ? []
            : List<dynamic>.from(json['data_result']),
        errorData: json['error_data'] == null
            ? []
            : List<dynamic>.from(json['error_data']),
        textStatus: json['text_status'],
        error: json['error'],
      );
}
