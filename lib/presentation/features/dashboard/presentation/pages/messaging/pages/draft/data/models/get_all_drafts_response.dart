// lib/.../draft/data/models/get_all_drafts_response.dart
class AllDraftsData {
  final int? draftId;
  final String? draftTitle;
  final String? draftMessage;
  final String? dateCreated;

  AllDraftsData({
    this.draftId,
    this.draftTitle,
    this.draftMessage,
    this.dateCreated,
  });

  factory AllDraftsData.fromJson(Map<String, dynamic> json) => AllDraftsData(
        draftId: json['draft_id'] is int
            ? json['draft_id']
            : int.tryParse(json['draft_id']?.toString() ?? ''),
        draftTitle: json['draft_title']?.toString(),
        draftMessage: json['draft_message']?.toString(),
        dateCreated: json['date_created']?.toString(),
      );
}

class DraftsPagination {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;

  DraftsPagination({
    this.totalRecords = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.limit = 20,
  });

  factory DraftsPagination.fromJson(Map<String, dynamic> json) =>
      DraftsPagination(
        totalRecords: _asInt(json['total_records']),
        totalPages: _asInt(json['total_pages']),
        currentPage: _asInt(json['current_page']) == 0
            ? 1
            : _asInt(json['current_page']),
        limit: _asInt(json['limit']) == 0 ? 20 : _asInt(json['limit']),
      );

  static int _asInt(dynamic v) =>
      v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
}

/// Wraps the nested `data: { data: [...], pagination: {...} }` shape.
class GetAllDraftsResponse {
  final String? serverMessage;
  final bool? status;
  final List<AllDraftsData>? data;
  final DraftsPagination? pagination;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  GetAllDraftsResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.pagination,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory GetAllDraftsResponse.fromJson(Map<String, dynamic> json) {
    final inner = json['data'];
    List<AllDraftsData> list = [];
    DraftsPagination? pagination;

    if (inner is Map<String, dynamic>) {
      // New nested shape: { data: [...], pagination: {...} }
      if (inner['data'] is List) {
        list = List<AllDraftsData>.from(
            (inner['data'] as List).map((x) => AllDraftsData.fromJson(x)));
      }
      if (inner['pagination'] is Map<String, dynamic>) {
        pagination = DraftsPagination.fromJson(inner['pagination']);
      }
    } else if (inner is List) {
      // Defensive fallback in case an older flat-array shape is ever
      // returned again (e.g. by view_draft's error responses, which send
      // "data": []).
      list =
          List<AllDraftsData>.from(inner.map((x) => AllDraftsData.fromJson(x)));
    }

    return GetAllDraftsResponse(
      serverMessage: json['server_message'],
      status: json['status'],
      data: list,
      pagination: pagination,
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
}
