import 'package:pmcsms/presentation/features/history/presentation/data/model/sms_history_item.dart';

class ViewSmsResponse {
  final bool status;
  final String serverMessage;
  final SmsHistoryItem? data;

  const ViewSmsResponse({
    required this.status,
    required this.serverMessage,
    this.data,
  });

  factory ViewSmsResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return ViewSmsResponse(
      status: json['status'] == true,
      serverMessage: json['server_message']?.toString() ?? '',
      data: (dataJson is Map<String, dynamic> && dataJson.isNotEmpty)
          ? SmsHistoryItem.fromJson(dataJson)
          : null,
    );
  }
}
