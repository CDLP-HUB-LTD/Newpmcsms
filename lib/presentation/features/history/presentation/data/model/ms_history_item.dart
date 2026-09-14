import 'package:pmcsms/presentation/features/history/presentation/data/model/sms_history_item.dart';

class HistoryPagination {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;

  const HistoryPagination({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory HistoryPagination.fromJson(Map<String, dynamic> json) {
    return HistoryPagination(
      totalRecords: json['total_records'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      currentPage: json['current_page'] ?? 1,
      limit: json['limit'] ?? 20,
    );
  }

  static const empty = HistoryPagination(
    totalRecords: 0,
    totalPages: 0,
    currentPage: 1,
    limit: 20,
  );

  bool get hasNextPage => currentPage < totalPages;
}

class SmsHistoryResponse {
  final bool status;
  final String serverMessage;
  final List<SmsHistoryItem> items;
  final HistoryPagination pagination;

  const SmsHistoryResponse({
    required this.status,
    required this.serverMessage,
    required this.items,
    required this.pagination,
  });

  factory SmsHistoryResponse.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'];
    final dataMap =
        dataObj is Map<String, dynamic> ? dataObj : <String, dynamic>{};

    final rawList = dataMap['data'];
    final list = rawList is List
        ? rawList
            .whereType<Map<String, dynamic>>()
            .map(SmsHistoryItem.fromJson)
            .toList()
        : <SmsHistoryItem>[];

    final paginationJson = dataMap['pagination'];

    return SmsHistoryResponse(
      status: json['status'] == true,
      serverMessage: json['server_message']?.toString() ?? '',
      items: list,
      pagination: paginationJson is Map<String, dynamic>
          ? HistoryPagination.fromJson(paginationJson)
          : HistoryPagination.empty,
    );
  }
}
