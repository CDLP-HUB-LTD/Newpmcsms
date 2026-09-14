import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/network/dio_client.dart';

// ── Request models ───────────────────────────────────────────────────────

class GetTemplatesRequest {
  final String process; // CONFIRM: e.g. 'whatsapp'
  final String action; // CONFIRM: e.g. 'get_templates'
  final String search;

  GetTemplatesRequest({
    this.process = 'whatsapp',
    this.action = 'get_templates',
    this.search = '',
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'search': search,
      };
}

class CreateTemplateRequest {
  final String process; // CONFIRM: e.g. 'whatsapp'
  final String action; // CONFIRM: e.g. 'create_template'
  final String name;
  final String message;
  final String language;
  final String requiredParameters;
  final String templateType;

  CreateTemplateRequest({
    this.process = 'whatsapp',
    this.action = 'create_template',
    required this.name,
    required this.message,
    required this.language,
    required this.requiredParameters,
    required this.templateType,
  });

  Map<String, dynamic> toJson() => {
        'process': process,
        'action': action,
        'name': name,
        'message': message,
        'language': language,
        'required_parameters': requiredParameters,
        'template_type': templateType,
      };
}

// ── Response model ───────────────────────────────────────────────────────

class WhatsappTemplate {
  final int id;
  final String code;
  final String text;
  final String preview;
  final String language;
  final List<String> requiredParameters;
  final String templateType;
  final String createdAt;

  WhatsappTemplate({
    required this.id,
    required this.code,
    required this.text,
    required this.preview,
    required this.language,
    required this.requiredParameters,
    required this.templateType,
    required this.createdAt,
  });

  factory WhatsappTemplate.fromJson(Map<String, dynamic> json) {
    return WhatsappTemplate(
      id: json['id'] as int? ?? 0,
      code: json['code']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      preview: json['preview']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      requiredParameters: (json['required_parameters']?.toString() ?? '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      templateType: json['template_type']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

// ── Repository ────────────────────────────────────────────────────────────

class WhatsappTemplateRepository {
  final Dio _dio;
  WhatsappTemplateRepository(this._dio);

  Future<List<WhatsappTemplate>> getTemplates({String search = ''}) async {
    final request = GetTemplatesRequest(search: search);
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    final list = response.data['data'] as List? ?? [];
    return list
        .map((e) => WhatsappTemplate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WhatsappTemplate> createTemplate({
    required String name,
    required String message,
    required String language,
    required String requiredParameters,
    required String templateType,
  }) async {
    final request = CreateTemplateRequest(
      name: name,
      message: message,
      language: language,
      requiredParameters: requiredParameters,
      templateType: templateType,
    );
    final response = await _dio.post('/pmcsms.php', data: request.toJson());
    return WhatsappTemplate.fromJson(response.data);
  }
}

final whatsappTemplateRepositoryProvider =
    Provider<WhatsappTemplateRepository>((ref) {
  final dio = ref.watch(appDioProvider);
  return WhatsappTemplateRepository(dio);
});
