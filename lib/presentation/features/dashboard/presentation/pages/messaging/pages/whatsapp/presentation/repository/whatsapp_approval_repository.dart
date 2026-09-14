import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';

// ── Request models ───────────────────────────────────────────────────────

class RequestNumberApprovalRequest {
  final String process; // CONFIRM: e.g. 'whatsapp'
  final String action; // CONFIRM: e.g. 'request_number_approval'
  final String username;
  final String whatsappNumber;
  final String whatsappName;

  RequestNumberApprovalRequest({
    this.process = 'whatsapp',
    this.action = 'request_number_approval',
    required this.username,
    required this.whatsappNumber,
    required this.whatsappName,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'username': username,
        'whatsapp_number': whatsappNumber,
        'whatsapp_name': whatsappName,
      };
}

class GetApprovedNumbersRequest {
  final String process; // CONFIRM: e.g. 'whatsapp'
  final String action; // CONFIRM: e.g. 'get_approved_numbers'

  GetApprovedNumbersRequest({
    this.process = 'whatsapp',
    this.action = 'get_approved_numbers',
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
      };
}

// ── Response models ──────────────────────────────────────────────────────

class ApprovedNumber {
  final int id;
  final String username;
  final String whatsappNumber;
  final String whatsappName;
  final String approvalStatus;

  ApprovedNumber({
    required this.id,
    required this.username,
    required this.whatsappNumber,
    required this.whatsappName,
    required this.approvalStatus,
  });

  factory ApprovedNumber.fromJson(Map<String, dynamic> json) {
    return ApprovedNumber(
      id: json['id'] as int? ?? 0,
      username: json['username']?.toString() ?? '',
      whatsappNumber: json['whatsapp_number']?.toString() ?? '',
      whatsappName: json['whatsapp_name']?.toString() ?? '',
      approvalStatus: json['approval_status']?.toString() ?? '',
    );
  }
}

// ── Repository ────────────────────────────────────────────────────────────

class WhatsappApprovalRepository {
  final Dio _dio;
  WhatsappApprovalRepository(this._dio);

  Future<void> requestNumberApproval({
    required String username,
    required String whatsappNumber,
    required String whatsappName,
  }) async {
    final request = RequestNumberApprovalRequest(
      username: username,
      whatsappNumber: whatsappNumber,
      whatsappName: whatsappName,
    );
    await _dio.post('/pmcsms.php', data: request.toJson());
  }

  Future<List<ApprovedNumber>> getApprovedNumbers() async {
    final response = await _dio.post(
      '/pmcsms.php',
      data: GetApprovedNumbersRequest().toJson(),
    );
    final list = response.data['data'] as List? ?? [];
    return list
        .map((e) => ApprovedNumber.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final whatsappApprovalRepositoryProvider =
    Provider<WhatsappApprovalRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return WhatsappApprovalRepository(dio);
});
