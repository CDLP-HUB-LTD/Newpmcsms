import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';

// ── Request models ───────────────────────────────────────────────────────

class TestMessageRequest {
  final String process; // CONFIRM: e.g. 'whatsapp'
  final String action; // CONFIRM: e.g. 'test_message'
  final int templateId;
  final String whatsappNumber;
  final Map<String, String> parameters;

  TestMessageRequest({
    this.process = 'whatsapp',
    this.action = 'test_message',
    required this.templateId,
    required this.whatsappNumber,
    required this.parameters,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'template_id': templateId,
        'whatsapp_number': whatsappNumber,
        'parameters': parameters,
      };
}

class SendMessageRequest {
  final String process; // CONFIRM: e.g. 'whatsapp'
  final String action; // CONFIRM: e.g. 'send_message'
  final int templateId;
  final String whatsappNumber;
  final Map<String, String> parameters;

  SendMessageRequest({
    this.process = 'whatsapp',
    this.action = 'send_message',
    required this.templateId,
    required this.whatsappNumber,
    required this.parameters,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'template_id': templateId,
        'whatsapp_number': whatsappNumber,
        'parameters': parameters,
      };
}

// ── Response model ───────────────────────────────────────────────────────

class WhatsappSendResult {
  final bool success;
  final String? previewMessage; // from test_message
  final String? referenceId; // from send_message
  final String? status;
  final String? cost;

  WhatsappSendResult({
    required this.success,
    this.previewMessage,
    this.referenceId,
    this.status,
    this.cost,
  });

  factory WhatsappSendResult.fromTestJson(Map<String, dynamic> json) {
    return WhatsappSendResult(
      success: json['status'] == 'success',
      previewMessage: json['preview_message']?.toString(),
      cost: json['would_be_cost']?.toString(),
    );
  }

  factory WhatsappSendResult.fromSendJson(Map<String, dynamic> json) {
    return WhatsappSendResult(
      success: true,
      referenceId: json['reference_id']?.toString(),
      status: json['status']?.toString(),
      cost: json['cost']?.toString(),
    );
  }
}

// ── Repository ────────────────────────────────────────────────────────────

class WhatsappMessageRepository {
  final Dio _dio;
  WhatsappMessageRepository(this._dio);

  Future<WhatsappSendResult> sendTestMessage({
    required int templateId,
    required String whatsappNumber,
    required Map<String, String> parameters,
  }) async {
    final request = TestMessageRequest(
      templateId: templateId,
      whatsappNumber: whatsappNumber,
      parameters: parameters,
    );
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return WhatsappSendResult.fromTestJson(response.data);
  }

  Future<WhatsappSendResult> sendMessage({
    required int templateId,
    required String whatsappNumber,
    required Map<String, String> parameters,
  }) async {
    final request = SendMessageRequest(
      templateId: templateId,
      whatsappNumber: whatsappNumber,
      parameters: parameters,
    );
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return WhatsappSendResult.fromSendJson(response.data);
  }
}

final whatsappMessageRepositoryProvider =
    Provider<WhatsappMessageRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return WhatsappMessageRepository(dio);
});
