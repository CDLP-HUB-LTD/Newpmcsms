import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';

// ── Request models ───────────────────────────────────────────────────────

class GetReportsRequest {
  final String process; // CONFIRM: e.g. 'whatsapp'
  final String action; // CONFIRM: e.g. 'get_reports'
  final String from;
  final String to;
  final String search;

  GetReportsRequest({
    this.process = 'whatsapp',
    this.action = 'get_reports',
    this.from = '',
    this.to = '',
    this.search = '',
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'from': from,
        'to': to,
        'search': search,
      };
}

class ExportReportsRequest {
  final String process; // CONFIRM: e.g. 'whatsapp'
  final String action; // CONFIRM: e.g. 'export_reports'
  final String from;
  final String to;

  ExportReportsRequest({
    this.process = 'whatsapp',
    this.action = 'export_reports',
    this.from = '',
    this.to = '',
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'from': from,
        'to': to,
      };
}

// ── Response model ───────────────────────────────────────────────────────

class WhatsappReport {
  final String referenceId;
  final String subject;
  final String callerId;
  final String receiver;
  final String cost;
  final String status;
  final String createdAt;

  WhatsappReport({
    required this.referenceId,
    required this.subject,
    required this.callerId,
    required this.receiver,
    required this.cost,
    required this.status,
    required this.createdAt,
  });

  factory WhatsappReport.fromJson(Map<String, dynamic> json) {
    return WhatsappReport(
      referenceId: json['reference_id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      callerId: json['caller_id']?.toString() ?? '',
      receiver: json['receiver']?.toString() ?? '',
      cost: json['cost']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

// ── Repository ────────────────────────────────────────────────────────────

class WhatsappReportRepository {
  final Dio _dio;
  WhatsappReportRepository(this._dio);

  Future<List<WhatsappReport>> getReports({
    String from = '',
    String to = '',
    String search = '',
  }) async {
    final request = GetReportsRequest(from: from, to: to, search: search);
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    final list = response.data['data'] as List? ?? [];
    return list
        .map((e) => WhatsappReport.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Returns a downloadable file URL. If the backend streams raw CSV bytes
  /// instead of a URL, switch responseType to ResponseType.bytes and save
  /// to disk with e.g. path_provider instead of reading response.data as JSON.
  Future<String> exportReports({String from = '', String to = ''}) async {
    final request = ExportReportsRequest(from: from, to: to);
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return response.data['file_url']?.toString() ?? '';
  }
}

final whatsappReportRepositoryProvider =
    Provider<WhatsappReportRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return WhatsappReportRepository(dio);
});
