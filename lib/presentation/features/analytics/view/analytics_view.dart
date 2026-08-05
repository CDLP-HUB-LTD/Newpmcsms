import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class AnalyticsView extends ConsumerStatefulWidget {
  const AnalyticsView({super.key});
  static const String routeName = '/analytics';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends ConsumerState<AnalyticsView> {
  String _reportTimeframe = 'This month';
  String _insightTimeframe = 'This month';
  String _costInsightType = 'SMS';

  final List<String> _timeframeOptions = [
    'This week',
    'This month',
    'This year',
  ];

  final List<String> _serviceTypeOptions = [
    'SMS',
    'Email',
    'Voice SMS',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Analytics'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildReportSection(),
              const VerticalSpacing(20),
              _buildMessageInsightSection(),
              const VerticalSpacing(20),
              _buildCostInsightSection(),
              const VerticalSpacing(24),
            ],
          ),
        ),
      ),
    );
  }

  // ── 1. REPORT SECTION ──────────────────────────────────────────────────────
  Widget _buildReportSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryF5F7F9,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Report', style: context.textTheme.s16w600),
              _buildDropdownFilter(
                value: _reportTimeframe,
                items: _timeframeOptions,
                onChanged: (val) => setState(() => _reportTimeframe = val!),
              ),
            ],
          ),
          const VerticalSpacing(16),
          const _ReportStatTile(
            title: 'Total Messages',
            count: '5,000,000',
            iconColor: Colors.deepPurpleAccent,
            bgColor: Color(0xFFF0EBFF),
          ),
          const VerticalSpacing(12),
          const _ReportStatTile(
            title: 'Delivered',
            count: '5,000,000',
            iconColor: Colors.green,
            bgColor: Color(0xFFEAF8F0),
          ),
          const VerticalSpacing(12),
          const _ReportStatTile(
            title: 'Failed',
            count: '5,000,000',
            iconColor: Colors.redAccent,
            bgColor: Color(0xFFFFEAEA),
          ),
          const VerticalSpacing(12),
          const _ReportStatTile(
            title: 'Pending',
            count: '5,000,000',
            iconColor: Colors.amber,
            bgColor: Color(0xFFFFF7EA),
          ),
        ],
      ),
    );
  }

  // ── 2. MESSAGE INSIGHT SECTION ─────────────────────────────────────────────
  Widget _buildMessageInsightSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryF5F7F9,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Message Insight', style: context.textTheme.s16w600),
              _buildDropdownFilter(
                value: _insightTimeframe,
                items: _timeframeOptions,
                onChanged: (val) => setState(() => _insightTimeframe = val!),
              ),
            ],
          ),
          const VerticalSpacing(12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '229 ',
                  style: context.textTheme.s20w600
                      .copyWith(color: AppColors.black),
                ),
                TextSpan(
                  text: 'messages sent',
                  style: context.textTheme.s12w400
                      .copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const VerticalSpacing(4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '↑ 12% from last week',
              style:
                  context.textTheme.s10w500.copyWith(color: Colors.green[700]),
            ),
          ),
          const VerticalSpacing(20),
          // Donut Chart Graphic
          Center(
            child: SizedBox(
              width: 140.w,
              height: 140.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140.w,
                    height: 140.w,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 16.r,
                      color: AppColors.primaryColor,
                      backgroundColor: Colors.cyan,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+14%',
                        style: context.textTheme.s16w600
                            .copyWith(color: Colors.green[700]),
                      ),
                      Text(
                        'from last week',
                        style: context.textTheme.s10w400
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const VerticalSpacing(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _LegendItem(
                  color: Colors.cyan, title: 'SMS', subTitle: '20 Messages'),
              _LegendItem(
                  color: AppColors.primaryColor,
                  title: 'Email',
                  subTitle: '20 entries'),
              _LegendItem(
                  color: Colors.redAccent,
                  title: 'Voice SMS',
                  subTitle: '20 entries'),
            ],
          ),
        ],
      ),
    );
  }

  // ── 3. COST INSIGHT SECTION ────────────────────────────────────────────────
  Widget _buildCostInsightSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryF5F7F9,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cost Insight', style: context.textTheme.s16w600),
              _buildDropdownFilter(
                value: _costInsightType,
                items: _serviceTypeOptions,
                onChanged: (val) => setState(() => _costInsightType = val!),
              ),
            ],
          ),
          const VerticalSpacing(12),
          Text(
            'NGN200,000',
            style: context.textTheme.s18w600,
          ),
          const VerticalSpacing(2),
          Text(
            '500 unit purchased',
            style: context.textTheme.s12w400.copyWith(color: Colors.grey[600]),
          ),
          const VerticalSpacing(24),
          // Bar Chart Graphics
          SizedBox(
            height: 160.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBar('Jan', 0.2, false),
                _buildBar('Feb', 0.4, false),
                _buildBar('Mar', 0.25, false),
                _buildBar('Apr', 0.5, false),
                _buildBar('May', 0.65, false),
                _buildBar('Jun', 0.9, true, tooltip: 'N20,000\n20 Unit'),
                _buildBar('Jul', 0.45, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Bar Graph Items
  Widget _buildBar(String month, double heightFactor, bool isSelected,
      {String? tooltip}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isSelected && tooltip != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              tooltip,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 8.sp),
            ),
          ),
          const VerticalSpacing(4),
        ],
        Container(
          width: 24.w,
          height: 100.h * heightFactor,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        const VerticalSpacing(8),
        Text(month, style: context.textTheme.s10w400),
      ],
    );
  }

  // Reusable Dropdown Filter Widget
  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.primaryE6E6E6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
          style: context.textTheme.s12w400.copyWith(color: AppColors.black),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── SUB-WIDGETS ──────────────────────────────────────────────────────────────

class _ReportStatTile extends StatelessWidget {
  const _ReportStatTile({
    required this.title,
    required this.count,
    required this.iconColor,
    required this.bgColor,
  });

  final String title;
  final String count;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: context.textTheme.s12w400
                      .copyWith(color: Colors.grey[600])),
              const VerticalSpacing(2),
              Text(count, style: context.textTheme.s14w600),
            ],
          ),
          CircleAvatar(
            radius: 16.r,
            backgroundColor: bgColor,
            child: Icon(Icons.chat_bubble_outline_rounded,
                color: iconColor, size: 16.r),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.title,
    required this.subTitle,
  });

  final Color color;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        const HorizontalSpacing(6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.textTheme.s12w500),
            Text(
              subTitle,
              style:
                  context.textTheme.s10w400.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
