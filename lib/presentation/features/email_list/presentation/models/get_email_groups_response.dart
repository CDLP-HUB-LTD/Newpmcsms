// lib/presentation/features/email_list/data/model/get_email_groups_response.dart
import 'email_group.dart';

class GetEmailGroupsResponse {
  final String? serverMessage;
  final bool? status;
  final List<EmailGroupData>? data;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  GetEmailGroupsResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory GetEmailGroupsResponse.fromJson(Map<String, dynamic> json) =>
      GetEmailGroupsResponse(
        serverMessage: json['server_message'],
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<EmailGroupData>.from(
                (json['data'] as List).map((x) => EmailGroupData.fromJson(x))),
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
