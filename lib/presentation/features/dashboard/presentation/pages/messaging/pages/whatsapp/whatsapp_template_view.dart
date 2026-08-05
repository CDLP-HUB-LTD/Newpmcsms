import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/custom_text_field.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class WhatsappTemplateView extends ConsumerWidget {
  const WhatsappTemplateView({super.key});
  static const String routeName = '/whatsapp-templates';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Whatsapp Template'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => _showAddTemplateBottomSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              const CustomTextField(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              const VerticalSpacing(16),
              Expanded(
                child: ListView.separated(
                  itemCount: 8,
                  separatorBuilder: (_, __) => const VerticalSpacing(12),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _showTemplateDetailsDialog(context),
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.primaryE6E6E6),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '#1253647',
                              style: context.textTheme.s10w400
                                  .copyWith(color: Colors.grey),
                            ),
                            const HorizontalSpacing(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lorem ipsum dolor sit amet consec...',
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
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'Authentication',
                                style: context.textTheme.s10w400,
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

  void _showTemplateDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: Text(
          'Template Details',
          textAlign: TextAlign.center,
          style: context.textTheme.s14w600,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Template Code : 12345', style: context.textTheme.s12w400),
            const VerticalSpacing(4),
            Text(
              'Template Text : Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet...',
              style: context.textTheme.s12w400,
            ),
            const VerticalSpacing(4),
            Text('Preview Message : Lorem ipsum',
                style: context.textTheme.s12w400),
            const VerticalSpacing(4),
            Text('Language : eng', style: context.textTheme.s12w400),
            const VerticalSpacing(4),
            Text('Required Parameters : qwa', style: context.textTheme.s12w400),
            const VerticalSpacing(4),
            Text('Date : 12-12-2022 12:00', style: context.textTheme.s12w400),
            const VerticalSpacing(6),
            Row(
              children: [
                Text('Template Type : ', style: context.textTheme.s12w400),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child:
                      Text('Authentication', style: context.textTheme.s10w400),
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

  void _showAddTemplateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.w,
            right: 16.w,
            top: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add New Template', style: context.textTheme.s16w600),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const VerticalSpacing(12),
              const CustomTextField(label: 'Template Name'),
              const VerticalSpacing(12),
              const CustomTextField(label: 'Message', maxLines: 3),
              const VerticalSpacing(12),
              const CustomTextField(label: 'Language'),
              const VerticalSpacing(12),
              const CustomTextField(label: 'Required Parameters'),
              const VerticalSpacing(12),
              const CustomTextField(
                label: 'Template Type',
                hintText: 'Select Template Type',
                suffixIcon: Icon(Icons.keyboard_arrow_down),
              ),
              const VerticalSpacing(20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const HorizontalSpacing(12),
                  Expanded(
                    child: CustomButton(
                      text: 'Save',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const VerticalSpacing(20),
            ],
          ),
        );
      },
    );
  }
}
