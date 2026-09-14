// lib/presentation/features/analytics/data/model/message_insight_response.dart
class MessageInsightData {
  final int sms;
  final int email;
  final int whatsapp;
  final int voicesms;

  MessageInsightData({
    this.sms = 0,
    this.email = 0,
    this.whatsapp = 0,
    this.voicesms = 0,
  });

  int get total => sms + email + whatsapp + voicesms;

  factory MessageInsightData.fromJson(Map<String, dynamic> json) =>
      MessageInsightData(
        sms: _asInt(json['sms']),
        email: _asInt(json['email']),
        whatsapp: _asInt(json['whatsapp']),
        voicesms: _asInt(json['voicesms']),
      );

  static int _asInt(dynamic v) =>
      v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
}

class MessageInsightResponse {
  final String? serverMessage;
  final bool? status;
  final MessageInsightData? data;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  MessageInsightResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory MessageInsightResponse.fromJson(Map<String, dynamic> json) =>
      MessageInsightResponse(
        serverMessage: json['server_message'],
        status: json['status'],
        data: json['data'] is Map<String, dynamic>
            ? MessageInsightData.fromJson(json['data'])
            : null,
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
