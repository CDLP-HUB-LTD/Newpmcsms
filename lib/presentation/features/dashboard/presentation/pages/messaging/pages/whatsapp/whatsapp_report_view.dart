import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';
import 'package:pmcsms/presentation/general_widgets/custom_text_field.dart';
import 'package:pmcsms/presentation/general_widgets/custom_text_field.dart';

class WhatsappReportsView extends ConsumerWidget {
  const WhatsappReportsView({super.key});
  static const String routeName = '/whatsapp-reports';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Reports'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'From',
                      hintText: 'MM/DD/YYYY',
                      suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                    ),
                  ),
                  HorizontalSpacing(12),
                  Expanded(
                    child: CustomTextField(
                      label: 'To',
                      hintText: 'MM/DD/YYYY',
                      suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                    ),
                  ),
                ],
              ),
              const VerticalSpacing(16),
              CustomButton(
                text: 'Export to CSV',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('You have successfully downloaded the report.'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
              ),
              const VerticalSpacing(20),
              const CustomTextField(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.tune),
              ),
              const VerticalSpacing(16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (_, __) => const VerticalSpacing(12),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _showReportDetailsDialog(context),
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.primaryE6E6E6),
                      ),
                      child: Row(
                        children: [
                          Text('#1253647',
                              style: context.textTheme.s10w400
                                  .copyWith(color: Colors.grey)),
                          const HorizontalSpacing(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lorem ipsum dolor sit amet...',
                                  style: context.textTheme.s12w500,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '12-12-2022 12:00',
                                  style: context.textTheme.s10w400
                                      .copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('N20', style: context.textTheme.s12w600),
                              const VerticalSpacing(2),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'Delivered',
                                  style: context.textTheme.s10w500
                                      .copyWith(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: Text('View Whatsapp Details',
            textAlign: TextAlign.center, style: context.textTheme.s14w600),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(context, 'Reference ID', '#12345'),
            _detailRow(context, 'Subject',
                'Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet...'),
            _detailRow(context, 'Caller ID', '07044838299'),
            _detailRow(context, 'Receiver', '07044838299'),
            _detailRow(context, 'Cost', 'N20'),
            _detailRow(context, 'Date', '12-12-2022 12:00'),
            Row(
              children: [
                Text('Status : ',
                    style:
                        context.textTheme.s12w400.copyWith(color: Colors.grey)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text('Delivered',
                      style: context.textTheme.s10w500
                          .copyWith(color: Colors.green)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'Close',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: '$label : ',
                style: context.textTheme.s12w400.copyWith(color: Colors.grey)),
            TextSpan(
                text: value,
                style: context.textTheme.s12w500.copyWith(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
