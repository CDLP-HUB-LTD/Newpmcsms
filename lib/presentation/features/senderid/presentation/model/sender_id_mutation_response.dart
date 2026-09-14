// lib/presentation/features/senderid/data/model/sender_id_mutation_response.dart
/// Shared response shape for create_sender_id / delete_sender_id.
class SenderIdMutationResponse {
  final String? serverMessage;
  final bool? status;
  final List<dynamic>? data;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  SenderIdMutationResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory SenderIdMutationResponse.fromJson(Map<String, dynamic> json) =>
      SenderIdMutationResponse(
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
