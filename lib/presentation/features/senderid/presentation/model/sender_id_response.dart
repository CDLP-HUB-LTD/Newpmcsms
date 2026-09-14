// lib/presentation/features/senderid/presentation/model/sender_id_response.dart

import 'dart:convert';

class SenderIdListItem {
  final int id;
  final String senderId; // maps to sender_name — the display value the UI shows
  final String service;
  final String status;
  final List<String> userIds;

  SenderIdListItem({
    required this.id,
    required this.senderId,
    required this.service,
    required this.status,
    this.userIds = const [],
  });

  factory SenderIdListItem.fromJson(Map<String, dynamic> json) =>
      SenderIdListItem(
        id: json['sender_id'] is int
            ? json['sender_id'] as int
            : int.tryParse(json['sender_id']?.toString() ?? '') ?? 0,
        senderId: json['sender_name']?.toString() ?? '',
        service: json['service']?.toString() ?? '',
        status: _statusFromCode(json['sender_status']),
        userIds: _parseUserIds(json['user_ids']),
      );

  static List<String> _parseUserIds(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((x) => x.toString()).toList();
    }
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map((x) => x.toString()).toList();
        }
      } catch (_) {
        // Not valid JSON either — fall through to empty list rather than crash.
      }
    }
    return [];
  }

  static String _statusFromCode(dynamic code) {
    final normalized =
        code is int ? code : int.tryParse(code?.toString() ?? '');
    switch (normalized) {
      case 1:
        return 'Active';
      case 2:
        return 'Failed';
      case 0:
      default:
        return 'Under Review';
    }
  }
}

class GetServiceSenderIdResponse {
  final String? serverMessage;
  final bool? status;
  final List<SenderIdListItem>? data;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  GetServiceSenderIdResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory GetServiceSenderIdResponse.fromJson(Map<String, dynamic> json) =>
      GetServiceSenderIdResponse(
        serverMessage: json['server_message'],
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<SenderIdListItem>.from((json['data'] as List)
                .map((x) => SenderIdListItem.fromJson(x))),
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
