import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/model/sender_id_response.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/notifier/sender_id_list_notifier.dart';
import 'package:pmcsms/presentation/features/senderid/views/create_sender_id_view.dart';
import 'package:pmcsms/presentation/features/senderid/views/delete_sender_id_notifier.dart';
import 'package:pmcsms/presentation/features/senderid/views/delete_sender_id_request.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// UI-facing tab. `.voiceSms` is deliberately named to match the tab label
/// ("Voice SMS") shown to users — the backend's `service` value is different
/// and is produced by [SenderIdServiceTabX.apiValue] below, never used directly.
enum SenderIdServiceTab { sms, email, voiceSms }

extension SenderIdServiceTabX on SenderIdServiceTab {
  /// Maps the UI tab to the exact `service` string the API expects.
  /// Confirmed against create_sender_id (voice) and get_service_sender_id
  /// Postman specs: 'sms' | 'email' | 'voice'.
  String get apiValue {
    switch (this) {
      case SenderIdServiceTab.sms:
        return 'sms';
      case SenderIdServiceTab.email:
        return 'email';
      case SenderIdServiceTab.voiceSms:
        return 'voice';
    }
  }

  String get label {
    switch (this) {
      case SenderIdServiceTab.sms:
        return 'SMS';
      case SenderIdServiceTab.email:
        return 'Email';
      case SenderIdServiceTab.voiceSms:
        return 'Voice SMS';
    }
  }
}

class SenderIdView extends ConsumerStatefulWidget {
  const SenderIdView({super.key});
  static const String routeName = '/senderId';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SenderIdViewState();
}

class _SenderIdViewState extends ConsumerState<SenderIdView> {
  final _searchController = TextEditingController();
  SenderIdServiceTab _selectedTab = SenderIdServiceTab.sms;
  String _selectedStatusFilter = 'All Status';

  @override
  void initState() {
    super.initState();
    // GET get_service_sender_id?service=sms is called on mount for the
    // default tab; switching tabs below re-fetches for the new service.
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchList());
  }

  void _fetchList() {
    ref.read(senderIdListNotifier.notifier).getSenderIds(
          service: _selectedTab.apiValue,
          onError: (error) => context.showError(message: error),
        );
  }

  List<SenderIdListItem> _applyFilters(List<SenderIdListItem> items) {
    final query = _searchController.text.trim().toLowerCase();
    return items.where((item) {
      final matchesStatus = _selectedStatusFilter == 'All Status' ||
          item.status == _selectedStatusFilter;
      final matchesQuery =
          query.isEmpty || item.senderId.toLowerCase().contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDeleting =
        ref.watch(deleteSenderIdNotifier.select((v) => v.isLoading));
    final listState = ref.watch(senderIdListNotifier);
    final items = _applyFilters(listState.items);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Sender ID'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildServiceTabs(),
              const VerticalSpacing(16),
              _buildSearchField(),
              const VerticalSpacing(16),
              _buildFilterDropdown(),
              const VerticalSpacing(16),
              Expanded(
                child: _buildBody(listState, items, isDeleting),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: () {
          context.pushNamed(
            CreateSenderIdView.routeName,
            arguments: _selectedTab.apiValue,
          );
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildBody(
    SenderIdListState listState,
    List<SenderIdListItem> items,
    bool isDeleting,
  ) {
    if (listState.isLoading && listState.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (listState.error != null && listState.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Couldn\'t load sender IDs',
              style: context.textTheme.s12w400.copyWith(color: Colors.grey),
            ),
            const VerticalSpacing(8),
            TextButton(onPressed: _fetchList, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No ${_selectedTab.label} sender IDs yet',
          style: context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _fetchList(),
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const VerticalSpacing(12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _SenderIdCard(
            item: item,
            isDeleting: isDeleting,
            onDelete: () => _showDeleteDialog(item),
          );
        },
      ),
    );
  }

  Widget _buildServiceTabs() {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.primaryF5F7F9,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children:
            SenderIdServiceTab.values.map((tab) => _buildTabItem(tab)).toList(),
      ),
    );
  }

  Widget _buildTabItem(SenderIdServiceTab tab) {
    final isSelected = _selectedTab == tab;
    return Expanded(
      child: InkWell(
        onTap: () {
          if (_selectedTab == tab) return;
          setState(() => _selectedTab = tab);
          _fetchList();
        },
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Text(
            tab.label,
            style: context.textTheme.s12w500.copyWith(
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: AppColors.primaryF5F7F9,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Align(
      alignment: Alignment.centerLeft,
      child: PopupMenuButton<String>(
        onSelected: (val) => setState(() => _selectedStatusFilter = val),
        itemBuilder: (_) => [
          _buildFilterMenuItem('All Status'),
          _buildFilterMenuItem('Active'),
          _buildFilterMenuItem('Under Review'),
          _buildFilterMenuItem('Failed'),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedStatusFilter,
              style: context.textTheme.s14w500,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildFilterMenuItem(String value) {
    final isSelected = _selectedStatusFilter == value;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value),
          if (isSelected)
            const Icon(Icons.check, size: 16, color: AppColors.primaryColor),
        ],
      ),
    );
  }

  void _showDeleteDialog(SenderIdListItem item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: const Text('Delete ID', textAlign: TextAlign.center),
        content: Text(
          'Are you sure you want to delete ${item.senderId}?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteSenderId(item);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteSenderId(SenderIdListItem item) {
    final data = DeleteSenderIdRequest(
      process: 'pm_messaging',
      action: 'delete_sender_id',
      service: item.service,
      senderId: item.senderId,
    );

    ref.read(deleteSenderIdNotifier.notifier).deleteSenderId(
          data: data,
          onError: (error) {
            context.showError(message: error);
          },
          onSuccess: (message) {
            ref
                .read(senderIdListNotifier.notifier)
                .removeLocally(item.senderId, item.service);
            context.showSuccess(message: message);
          },
        );
  }
}

class _SenderIdCard extends StatelessWidget {
  const _SenderIdCard({
    required this.item,
    required this.onDelete,
    this.isDeleting = false,
  });

  final SenderIdListItem item;
  final VoidCallback onDelete;
  final bool isDeleting;

  Color _getStatusColor() {
    switch (item.status) {
      case 'Active':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      case 'Under Review':
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.primaryF5F7F9,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.senderId, style: context.textTheme.s14w500),
              const VerticalSpacing(4),
              Text(
                item.status,
                style: context.textTheme.s12w400.copyWith(
                  color: _getStatusColor(),
                ),
              ),
            ],
          ),
          isDeleting
              ? SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (val) {
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Delete ID',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
