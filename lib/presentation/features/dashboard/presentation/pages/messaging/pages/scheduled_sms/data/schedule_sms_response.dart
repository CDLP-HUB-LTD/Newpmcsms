// lib/presentation/features/dashboard/presentation/pages/messaging/data/model/scheduled_sms_response.dart
class ScheduledSmsItem {
  final int? scheduleId;
  final String? senderId;
  final String? message;
  final String? recipient;
  final String? scheduleDate;
  final String? status;

  ScheduledSmsItem({
    this.scheduleId,
    this.senderId,
    this.message,
    this.recipient,
    this.scheduleDate,
    this.status,
  });

  /// GUESSED field names — every sample response for the list/view actions
  /// had an empty `data`, so these are inferred from create_schedule_sms's
  /// request fields (sender_id, message, recipient, schedule_date) plus an
  /// assumed schedule_id/status. Confirm against a real populated response
  /// before relying on this in production.
  factory ScheduledSmsItem.fromJson(Map<String, dynamic> json) =>
      ScheduledSmsItem(
        scheduleId: json['schedule_id'] is int
            ? json['schedule_id']
            : int.tryParse(json['schedule_id']?.toString() ?? ''),
        senderId: json['sender_id']?.toString(),
        message: json['message']?.toString(),
        recipient: json['recipient']?.toString(),
        scheduleDate: json['schedule_date']?.toString(),
        status: json['status']?.toString() ?? 'Pending',
      );
}

class ScheduledSmsPagination {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;

  ScheduledSmsPagination({
    this.totalRecords = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.limit = 20,
  });

  factory ScheduledSmsPagination.fromJson(Map<String, dynamic> json) =>
      ScheduledSmsPagination(
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

/// Wraps the nested `data: { data: [...], pagination: {...} }` shape —
/// same structure as GetAllDraftsResponse.
class GetScheduledSmsResponse {
  final String? serverMessage;
  final bool? status;
  final List<ScheduledSmsItem>? data;
  final ScheduledSmsPagination? pagination;
  final List<dynamic>? dataResult;
  final List<dynamic>? errorData;
  final String? textStatus;
  final dynamic error;

  GetScheduledSmsResponse({
    this.serverMessage,
    this.status,
    this.data,
    this.pagination,
    this.dataResult,
    this.errorData,
    this.textStatus,
    this.error,
  });

  factory GetScheduledSmsResponse.fromJson(Map<String, dynamic> json) {
    final inner = json['data'];
    List<ScheduledSmsItem> list = [];
    ScheduledSmsPagination? pagination;

    if (inner is Map<String, dynamic>) {
      if (inner['data'] is List) {
        list = List<ScheduledSmsItem>.from(
            (inner['data'] as List).map((x) => ScheduledSmsItem.fromJson(x)));
      }
      if (inner['pagination'] is Map<String, dynamic>) {
        pagination = ScheduledSmsPagination.fromJson(inner['pagination']);
      }
    } else if (inner is List) {
      list = List<ScheduledSmsItem>.from(
          inner.map((x) => ScheduledSmsItem.fromJson(x)));
    }

    return GetScheduledSmsResponse(
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

/// Single-item response for view_scheduled_message.
class ViewScheduledSmsResponse {
  final String? serverMessage;
  final bool? status;
  final ScheduledSmsItem? data;

  ViewScheduledSmsResponse({this.serverMessage, this.status, this.data});

  factory ViewScheduledSmsResponse.fromJson(Map<String, dynamic> json) =>
      ViewScheduledSmsResponse(
        serverMessage: json['server_message'],
        status: json['status'],
        data: json['data'] is Map<String, dynamic>
            ? ScheduledSmsItem.fromJson(json['data'])
            : null,
      );
}

/// Result payload for create_schedule_sms specifically — confirmed against
/// a real response:
/// { "reference": ..., "sms_id": ..., "total_recipients": ...,
///   "schedule_count": ..., "balance_before": ..., "total_amount": ...,
///   "balance_after": ... }
class ScheduledSmsCreateResult {
  final String? reference;
  final int? smsId;
  final int? totalRecipients;
  final int? scheduleCount;
  final num? balanceBefore;
  final num? totalAmount;
  final num? balanceAfter;

  ScheduledSmsCreateResult({
    this.reference,
    this.smsId,
    this.totalRecipients,
    this.scheduleCount,
    this.balanceBefore,
    this.totalAmount,
    this.balanceAfter,
  });

  factory ScheduledSmsCreateResult.fromJson(Map<String, dynamic> json) =>
      ScheduledSmsCreateResult(
        reference: json['reference']?.toString(),
        smsId: json['sms_id'] is int
            ? json['sms_id']
            : int.tryParse(json['sms_id']?.toString() ?? ''),
        totalRecipients: json['total_recipients'] is int
            ? json['total_recipients']
            : int.tryParse(json['total_recipients']?.toString() ?? ''),
        scheduleCount: json['schedule_count'] is int
            ? json['schedule_count']
            : int.tryParse(json['schedule_count']?.toString() ?? ''),
        balanceBefore: json['balance_before'] is num
            ? json['balance_before']
            : num.tryParse(json['balance_before']?.toString() ?? ''),
        totalAmount: json['total_amount'] is num
            ? json['total_amount']
            : num.tryParse(json['total_amount']?.toString() ?? ''),
        balanceAfter: json['balance_after'] is num
            ? json['balance_after']
            : num.tryParse(json['balance_after']?.toString() ?? ''),
      );
}

/// Shared response shape for create/update/delete mutations.
///
/// NOTE: `data` is kept as `dynamic` on purpose. The real payload shape
/// differs per action — create_schedule_sms returns a Map (see
/// [ScheduledSmsCreateResult] above), while other mutations may return a
/// List or nothing. Forcing this into `List<dynamic>` via `List.from(...)`
/// crashes at runtime whenever the server sends a Map instead
/// ("... is not a subtype of type 'Iterable<dynamic>'"), which is what was
/// happening for create_schedule_sms. If you need typed access to a
/// specific action's result, parse `data` with that action's dedicated
/// model (e.g. `ScheduledSmsCreateResult.fromJson(data as Map<String, dynamic>)`)
/// at the call site instead of adding more shapes here.
class ScheduledSmsMutationResponse {
  final String? serverMessage;
  final bool? status;
  final dynamic data;

  ScheduledSmsMutationResponse({this.serverMessage, this.status, this.data});

  factory ScheduledSmsMutationResponse.fromJson(Map<String, dynamic> json) =>
      ScheduledSmsMutationResponse(
        serverMessage: json['server_message'],
        status: json['status'],
        data: json['data'],
      );
}
