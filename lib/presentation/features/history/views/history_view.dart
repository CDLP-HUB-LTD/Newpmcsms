import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
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
  String _selectedStatus = 'All Status';
  String _selectedMonth = 'October';

  final List<String> _categories = ['SMS', 'Email', 'Voice SMS'];

  void _showStatusFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        final statuses = ['All Status', 'Successful', 'Pending', 'Failed'];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: statuses.map((status) {
              final isSelected = status == _selectedStatus;
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
                  setState(() => _selectedStatus = status);
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
                        onTap: () =>
                            setState(() => _selectedCategoryIndex = index),
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
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
              const VerticalSpacing(16),

              // Filter Dropdowns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _selectedMonth,
                    underline: const SizedBox(),
                    items: ['October', 'November', 'December']
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedMonth = val);
                    },
                  ),
                  GestureDetector(
                    onTap: _showStatusFilterModal,
                    child: Row(
                      children: [
                        Text(
                          _selectedStatus,
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
                child: ListView.separated(
                  itemCount: 4,
                  separatorBuilder: (_, __) => const VerticalSpacing(12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to MessageDetailsView
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
                                    'Bo',
                                    style: context.textTheme.s10w500,
                                  ),
                                ),
                                const HorizontalSpacing(8),
                                Expanded(
                                  child: Text(
                                    'Boluwatife Ogundiji & 25 others',
                                    style: context.textTheme.s12w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'Oct 22',
                                  style: context.textTheme.s10w400
                                      .copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                            const VerticalSpacing(8),
                            Text(
                              'Wishing each and everyone a happy holidays this season. We will be extending the break for two month...',
                              style: context.textTheme.s10w400
                                  .copyWith(color: Colors.grey[700]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const VerticalSpacing(8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                'Successful',
                                style: context.textTheme.s10w400
                                    .copyWith(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
