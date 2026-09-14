import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pmcsms/presentation/features/history/presentation/data/model/resend_sms_request.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/sms_history_item.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/sms_history_request.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/view_sms_request.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/view_sms_response.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/repository/history_repository.dart';

/// Maps the segmented-control index used in the UI to the `service`
/// value the API expects.
const List<String> kHistoryServices = ['sms', 'email', 'voice_sms'];

/// Maps the status filter labels shown in the UI to the API's status value.
const Map<String, String> kStatusFilterValues = {
  'All Status': 'all',
  'Successful': 'successful',
  'Pending': 'pending',
  'Failed': 'failed',
};

class HistoryState {
  final List<SmsHistoryItem> items;
  final bool isLoading; // initial / full-page load
  final bool isLoadingMore; // paginating
  final bool isRefreshing; // pull-to-refresh
  final String? error;
  final String service;
  final String statusLabel; // display label, e.g. 'All Status'
  final String search;
  final int currentPage;
  final int totalPages;

  const HistoryState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
    this.service = 'sms',
    this.statusLabel = 'All Status',
    this.search = '',
    this.currentPage = 1,
    this.totalPages = 1,
  });

  bool get hasNextPage => currentPage < totalPages;

  HistoryState copyWith({
    List<SmsHistoryItem>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    String? service,
    String? statusLabel,
    String? search,
    int? currentPage,
    int? totalPages,
  }) {
    return HistoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      service: service ?? this.service,
      statusLabel: statusLabel ?? this.statusLabel,
      search: search ?? this.search,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryRepository _repository;
  static const int _pageSize = 20;

  HistoryNotifier(this._repository, {String service = 'sms'})
      : super(HistoryState(service: service)) {
    fetchHistory(refresh: true);
  }

  Future<void> fetchHistory({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(isLoading: true, clearError: true, currentPage: 1);
    }

    try {
      final response = await _repository.getServiceHistory(
        SmsHistoryRequest(
          service: state.service,
          status: kStatusFilterValues[state.statusLabel] ?? 'all',
          start: 1,
          length: _pageSize,
          search: state.search,
        ),
      );

      if (!response.status) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: response.serverMessage.isNotEmpty
              ? response.serverMessage
              : 'Unable to load history',
        );
        return;
      }

      state = state.copyWith(
        items: response.items,
        isLoading: false,
        isRefreshing: false,
        clearError: true,
        currentPage: response.pagination.currentPage,
        totalPages: response.pagination.totalPages == 0
            ? 1
            : response.pagination.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, clearError: true);
    await fetchHistory();
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNextPage || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;

    try {
      final response = await _repository.getServiceHistory(
        SmsHistoryRequest(
          service: state.service,
          status: kStatusFilterValues[state.statusLabel] ?? 'all',
          start: nextPage,
          length: _pageSize,
          search: state.search,
        ),
      );

      if (!response.status) {
        state = state.copyWith(isLoadingMore: false);
        return;
      }

      state = state.copyWith(
        items: [...state.items, ...response.items],
        isLoadingMore: false,
        currentPage: response.pagination.currentPage,
        totalPages: response.pagination.totalPages == 0
            ? state.totalPages
            : response.pagination.totalPages,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void setService(String service) {
    if (service == state.service) return;
    state = state.copyWith(service: service, items: [], currentPage: 1);
    fetchHistory(refresh: true);
  }

  void setStatusLabel(String statusLabel) {
    if (statusLabel == state.statusLabel) return;
    state = state.copyWith(statusLabel: statusLabel, items: [], currentPage: 1);
    fetchHistory(refresh: true);
  }

  void setSearch(String value) {
    state = state.copyWith(search: value, items: [], currentPage: 1);
    fetchHistory(refresh: true);
  }
}

/// One notifier instance per `service` ('sms' | 'email' | 'voice_sms') so
/// switching tabs keeps each list's state around instead of refetching
/// every time the user flips back and forth.
final historyProvider =
    StateNotifierProvider.family<HistoryNotifier, HistoryState, String>(
        (ref, service) {
  final repository = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repository, service: service);
});

/// Fetches a single message's details (Details/Message tabs).
final messageDetailsProvider =
    FutureProvider.family<ViewSmsResponse, int>((ref, smsId) async {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.viewSms(ViewSmsRequest(smsId: smsId));
});

class ResendState {
  final bool isLoading;
  final bool? lastSucceeded;
  final String? message;

  const ResendState({this.isLoading = false, this.lastSucceeded, this.message});
}

class ResendSmsNotifier extends StateNotifier<ResendState> {
  final HistoryRepository _repository;

  ResendSmsNotifier(this._repository) : super(const ResendState());

  Future<void> resend(int smsId) async {
    state = const ResendState(isLoading: true);
    try {
      final response =
          await _repository.resendSms(ResendSmsRequest(smsId: smsId));
      state = ResendState(
        isLoading: false,
        lastSucceeded: response.status,
        message: response.serverMessage,
      );
    } catch (_) {
      state = const ResendState(
        isLoading: false,
        lastSucceeded: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }
}

final resendSmsProvider =
    StateNotifierProvider.autoDispose<ResendSmsNotifier, ResendState>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return ResendSmsNotifier(repository);
});
