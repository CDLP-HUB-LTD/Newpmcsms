// lib/presentation/features/analytics/data/model/cost_insight_response.dart
class CostInsightData {
  /// Month abbreviation ("Jan".."Dec") -> amount as double.
  final Map<String, double> monthlyCost;

  CostInsightData({required this.monthlyCost});

  double get total => monthlyCost.values.fold(0.0, (sum, v) => sum + v);

  factory CostInsightData.fromJson(Map<String, dynamic> json) {
    final map = <String, double>{};
    json.forEach((key, value) {
      map[key] = double.tryParse(value?.toString() ?? '') ?? 0.0;
    });
    return CostInsightData(monthlyCost: map);
  }
}

class CostInsightResponse {
  final String? serverMessage;
  final bool? status;
  final CostInsightData? data;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  CostInsightResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory CostInsightResponse.fromJson(Map<String, dynamic> json) =>
      CostInsightResponse(
        serverMessage: json['server_message'],
        status: json['status'],
        data: json['data'] is Map<String, dynamic>
            ? CostInsightData.fromJson(json['data'])
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
