import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/senderid/views/create_sender_id_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

enum SenderIdServiceTab { sms, email, voiceSms }

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

  // Example dummy data
  final List<_SenderIdItem> _senderIds = const [
    _SenderIdItem(title: '11678860073899W9', status: 'Active'),
    _SenderIdItem(title: '11678860073899W9', status: 'Failed'),
    _SenderIdItem(title: '11678860073899W9', status: 'Under Review'),
    _SenderIdItem(title: '11678860073899W9', status: 'Active'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: ListView.separated(
                  itemCount: _senderIds.length,
                  separatorBuilder: (_, __) => const VerticalSpacing(12),
                  itemBuilder: (context, index) {
                    final item = _senderIds[index];
                    return _SenderIdCard(
                      item: item,
                      onDelete: () => _showDeleteDialog(item),
                    );
                  },
                ),
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
          context.pushNamed(CreateSenderIdView.routeName);
        },
        child: const Icon(Icons.add, color: AppColors.white),
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
        children: [
          _buildTabItem('SMS', SenderIdServiceTab.sms),
          _buildTabItem('Email', SenderIdServiceTab.email),
          _buildTabItem('Voice SMS', SenderIdServiceTab.voiceSms),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, SenderIdServiceTab tab) {
    final isSelected = _selectedTab == tab;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = tab),
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
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

  void _showDeleteDialog(_SenderIdItem item) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: const Text('Delete ID', textAlign: TextAlign.center),
        content: const Text(
          'Are you sure you want to delete this ID',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: execute delete logic
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SenderIdItem {
  const _SenderIdItem({required this.title, required this.status});
  final String title;
  final String status;
}

class _SenderIdCard extends StatelessWidget {
  const _SenderIdCard({required this.item, required this.onDelete});
  final _SenderIdItem item;
  final VoidCallback onDelete;

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
              Text(item.title, style: context.textTheme.s14w500),
              const VerticalSpacing(4),
              Text(
                item.status,
                style: context.textTheme.s12w400.copyWith(
                  color: _getStatusColor(),
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) {
              if (val == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text('Delete ID', style: TextStyle(color: Colors.red)),
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
