import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/model/cost_insight_response.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/notifier/cost_insight_notifier.dart';
import 'package:pmcsms/presentation/features/analytics/presentation/notifier/message_insight_notifier.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messageInsightNotifier.notifier)
          .getMessageInsight(_durationFromLabel(_insightTimeframe));
      ref.read(costInsightNotifier.notifier).getCostInsight(
            serviceType: _serviceTypeFromLabel(_costInsightType),
            year: DateTime.now().year,
          );
    });
  }

  /// 'This week' / 'This month' / 'This year' -> 'this_week' / 'this_month' / 'this_year'.
  /// Confirmed against the one sample given ('this_month'); the week/year
  /// variants are inferred by pattern, not yet confirmed against the API.
  String _durationFromLabel(String label) {
    switch (label) {
      case 'This week':
        return 'this_week';
      case 'This year':
        return 'this_year';
      case 'This month':
      default:
        return 'this_month';
    }
  }

  /// 'SMS' / 'Email' / 'Voice SMS' -> 'sms' / 'email' / 'voicesms'.
  /// Only 'sms' has been confirmed against a real response so far.
  String _serviceTypeFromLabel(String label) {
    switch (label) {
      case 'Email':
        return 'email';
      case 'Voice SMS':
        return 'voicesms';
      case 'SMS':
      default:
        return 'sms';
    }
  }

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
              // _buildReportSection(),
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
  // NOTE: no endpoint has been provided for this section yet. Values below
  // remain hardcoded placeholders until pm_statistics exposes a report action.
  // Widget _buildReportSection() {
  //   return Container(
  //     padding: EdgeInsets.all(16.r),
  //     decoration: BoxDecoration(
  //       color: AppColors.primaryF5F7F9,
  //       borderRadius: BorderRadius.circular(12.r),
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Report', style: context.textTheme.s16w600),
  //             _buildDropdownFilter(
  //               value: _reportTimeframe,
  //               items: _timeframeOptions,
  //               onChanged: (val) => setState(() => _reportTimeframe = val!),
  //             ),
  //           ],
  //         ),
  //         const VerticalSpacing(16),
  //         const _ReportStatTile(
  //           title: 'Total Messages',
  //           count: '5,000,000',
  //           iconColor: Colors.deepPurpleAccent,
  //           bgColor: Color(0xFFF0EBFF),
  //         ),
  //         const VerticalSpacing(12),
  //         const _ReportStatTile(
  //           title: 'Delivered',
  //           count: '5,000,000',
  //           iconColor: Colors.green,
  //           bgColor: Color(0xFFEAF8F0),
  //         ),
  //         const VerticalSpacing(12),
  //         const _ReportStatTile(
  //           title: 'Failed',
  //           count: '5,000,000',
  //           iconColor: Colors.redAccent,
  //           bgColor: Color(0xFFFFEAEA),
  //         ),
  //         const VerticalSpacing(12),
  //         const _ReportStatTile(
  //           title: 'Pending',
  //           count: '5,000,000',
  //           iconColor: Colors.amber,
  //           bgColor: Color(0xFFFFF7EA),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ── 2. MESSAGE INSIGHT SECTION ─────────────────────────────────────────────
  Widget _buildMessageInsightSection() {
    final insightState = ref.watch(messageInsightNotifier);
    final isLoading = insightState.state == LoadState.loading;
    final data = insightState.data?.data;

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
                onChanged: (val) {
                  setState(() => _insightTimeframe = val!);
                  ref
                      .read(messageInsightNotifier.notifier)
                      .getMessageInsight(_durationFromLabel(val!));
                },
              ),
            ],
          ),
          const VerticalSpacing(12),
          if (isLoading && data == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${data?.total ?? 0} ',
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
            // No trend/growth figure is returned by the API for a single
            // duration snapshot, so the previous "↑ 12% from last week" and
            // "+14%" badges have been removed rather than shown with fake data.
            const VerticalSpacing(20),
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
                        value: (data?.total ?? 0) == 0
                            ? 0
                            : (data!.sms + data.email) / data.total,
                        strokeWidth: 16.r,
                        color: AppColors.primaryColor,
                        backgroundColor: Colors.cyan,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${data?.total ?? 0}',
                          style: context.textTheme.s16w600,
                        ),
                        Text(
                          'total',
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
              children: [
                _LegendItem(
                  color: Colors.cyan,
                  title: 'SMS',
                  subTitle: '${data?.sms ?? 0} Messages',
                ),
                _LegendItem(
                  color: AppColors.primaryColor,
                  title: 'Email',
                  subTitle: '${data?.email ?? 0} Messages',
                ),
                _LegendItem(
                  color: Colors.redAccent,
                  title: 'Voice SMS',
                  subTitle: '${data?.voicesms ?? 0} Messages',
                ),
              ],
            ),
            // whatsapp (data?.whatsapp) is returned by the API but has no
            // legend slot in this UI yet — surfaced here as a TODO rather
            // than silently dropped.
          ],
        ],
      ),
    );
  }

  // ── 3. COST INSIGHT SECTION ────────────────────────────────────────────────
  Widget _buildCostInsightSection() {
    final costState = ref.watch(costInsightNotifier);
    final isLoading = costState.state == LoadState.loading;
    final CostInsightData? data = costState.data?.data;

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'
      // Aug–Dec exist in the response but the original bar chart only
      // displayed 7 months; kept that layout rather than assuming a redesign.
    ];
    final maxValue = data == null
        ? 1.0
        : (data.monthlyCost.values.isEmpty
            ? 1.0
            : data.monthlyCost.values.reduce((a, b) => a > b ? a : b));

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
                onChanged: (val) {
                  setState(() => _costInsightType = val!);
                  ref.read(costInsightNotifier.notifier).getCostInsight(
                        serviceType: _serviceTypeFromLabel(val!),
                        year: DateTime.now().year,
                      );
                },
              ),
            ],
          ),
          const VerticalSpacing(12),
          if (isLoading && data == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            Text(
              'NGN${(data?.total ?? 0).toStringAsFixed(2)}',
              style: context.textTheme.s18w600,
            ),
            // "unit purchased" isn't returned by cost_insight — removed
            // rather than shown as a fake figure.
            const VerticalSpacing(24),
            SizedBox(
              height: 160.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: months.map((month) {
                  final value = data?.monthlyCost[month] ?? 0.0;
                  final heightFactor = maxValue == 0 ? 0.0 : (value / maxValue);
                  return _buildBar(
                    month,
                    heightFactor,
                    false,
                    tooltip: value > 0 ? 'N${value.toStringAsFixed(2)}' : null,
                  );
                }).toList(),
              ),
            ),
          ],
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
          height: 100.h * heightFactor.clamp(0.0, 1.0),
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
