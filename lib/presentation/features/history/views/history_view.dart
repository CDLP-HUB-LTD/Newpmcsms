import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/sms_history_item.dart';
import 'package:pmcsms/presentation/features/history/presentation/provider/history_providers.dart';
import 'package:pmcsms/presentation/features/history/views/message_details_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_text_field.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});
  static const String routeName = '/history';

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  int _selectedCategoryIndex = 0; // 0: SMS, 1: Email, 2: Voice SMS
  final List<String> _categories = ['SMS', 'Email', 'Voice SMS'];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  String get _currentService => kHistoryServices[_selectedCategoryIndex];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(historyProvider(_currentService).notifier).loadMore();
    }
  }

  void _onSearchChanged() {
    final value = _searchController.text;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(historyProvider(_currentService).notifier).setSearch(value);
    });
  }

  void _showStatusFilterModal() {
    final notifier = ref.read(historyProvider(_currentService).notifier);
    final currentStatus =
        ref.read(historyProvider(_currentService)).statusLabel;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        final statuses = kStatusFilterValues.keys.toList();
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: statuses.map((status) {
              final isSelected = status == currentStatus;
              return ListTile(
                title: Text(
                  status,
                  style: context.textTheme.s14w500.copyWith(
                    color: isSelected ? Colors.deepPurple : Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Colors.deepPurple)
                    : null,
                onTap: () {
                  notifier.setStatusLabel(status);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyProvider(_currentService));

    return Scaffold(
      appBar: const CustomAppBar(title: 'History'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              // Category Segment Control
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategoryIndex = index);
                          _searchController.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _categories[index],
                            style: context.textTheme.s12w500.copyWith(
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const VerticalSpacing(16),

              // Search Bar
              CustomTextField(
                controller: _searchController,
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
              const VerticalSpacing(16),

              // Filter row: status filter (server-backed)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${state.items.length} result${state.items.length == 1 ? '' : 's'}',
                    style:
                        context.textTheme.s12w500.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: _showStatusFilterModal,
                    child: Row(
                      children: [
                        Text(
                          state.statusLabel,
                          style: context.textTheme.s12w500,
                        ),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const VerticalSpacing(12),

              // History List
              Expanded(
                child: _buildBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(HistoryState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: context.textTheme.s12w500.copyWith(color: Colors.grey),
            ),
            const VerticalSpacing(12),
            OutlinedButton(
              onPressed: () => ref
                  .read(historyProvider(_currentService).notifier)
                  .fetchHistory(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Text(
          'No history yet',
          style: context.textTheme.s12w500.copyWith(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(historyProvider(_currentService).notifier).refresh(),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.items.length + (state.hasNextPage ? 1 : 0),
        separatorBuilder: (_, __) => const VerticalSpacing(12),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          return _HistoryTile(item: state.items[index]);
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final SmsHistoryItem item;
  const _HistoryTile({required this.item});

  Color _statusBg(String status) {
    switch (status) {
      case 'Successful':
        return Colors.green.shade50;
      case 'Failed':
        return Colors.red.shade50;
      default:
        return Colors.orange.shade50;
    }
  }

  Color _statusFg(String status) {
    switch (status) {
      case 'Successful':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formattedDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final status = item.displayStatus;
    final title = item.recipientCount > 1
        ? '${item.primaryRecipient} & ${item.recipientCount - 1} other${item.recipientCount - 1 == 1 ? '' : 's'}'
        : item.primaryRecipient;
    final initials = item.senderId.isNotEmpty
        ? item.senderId.substring(0, item.senderId.length >= 2 ? 2 : 1)
        : '?';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MessageDetailsView(smsId: item.smsId),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.primaryF5F7F9,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12.r,
                  backgroundColor: Colors.amber.shade200,
                  child: Text(
                    initials,
                    style: context.textTheme.s10w500,
                  ),
                ),
                const HorizontalSpacing(8),
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.s12w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formattedDate(item.createdAtDate),
                  style: context.textTheme.s10w400.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const VerticalSpacing(8),
            Text(
              item.message,
              style:
                  context.textTheme.s10w400.copyWith(color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const VerticalSpacing(8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _statusBg(status),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                status,
                style: context.textTheme.s10w400
                    .copyWith(color: _statusFg(status)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
