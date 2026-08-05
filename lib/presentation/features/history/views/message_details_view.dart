import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class MessageDetailsView extends ConsumerStatefulWidget {
  const MessageDetailsView({super.key});
  static const String routeName = '/messageDetails';

  @override
  ConsumerState<MessageDetailsView> createState() => _MessageDetailsViewState();
}

class _MessageDetailsViewState extends ConsumerState<MessageDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Message Details'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email sent to',
                      style: context.textTheme.s10w400
                          .copyWith(color: Colors.grey),
                    ),
                    const VerticalSpacing(6),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10.r,
                          backgroundColor: Colors.amber.shade200,
                          child: Text('Bo', style: context.textTheme.s10w500),
                        ),
                        const HorizontalSpacing(8),
                        Text(
                          'Boluwatife Ogundiji & 25 others',
                          style: context.textTheme.s12w600,
                        ),
                      ],
                    ),
                    const VerticalSpacing(12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF9EA3FF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            child: Text(
                              'Resend message',
                              style: context.textTheme.s12w500
                                  .copyWith(color: const Color(0xFF9EA3FF)),
                            ),
                          ),
                        ),
                        const HorizontalSpacing(12),
                        Expanded(
                          child: CustomButton(
                            text: 'New message',
                            backgroundColor: const Color(0xFF6C5CE7),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const VerticalSpacing(16),

              // TabBar
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.deepPurple,
                labelStyle: context.textTheme.s12w600,
                tabs: const [
                  Tab(text: 'Details'),
                  Tab(text: 'Message'),
                  Tab(text: 'Report'),
                ],
              ),
              const VerticalSpacing(16),

              // TabBar View Body
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailsTab(),
                    _buildMessageTab(),
                    _buildReportTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Details Tab
  Widget _buildDetailsTab() {
    return Column(
      children: [
        _buildDetailRow('Sender ID', '11456708957409999'),
        _buildDetailRow('Status', 'Successful', isBadge: true),
        _buildDetailRow('Date', '12-12-2022 12:00'),
        _buildDetailRow('Recipient', 'Boluwatife Ogundiji', showAvatar: true),
        _buildDetailRow('Fee', '2 Units'),
      ],
    );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    bool isBadge = false,
    bool showAvatar = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: context.textTheme.s12w400.copyWith(color: Colors.grey)),
          if (isBadge)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text('Successful',
                  style:
                      context.textTheme.s10w400.copyWith(color: Colors.green)),
            )
          else if (showAvatar)
            Row(
              children: [
                CircleAvatar(
                  radius: 10.r,
                  backgroundColor: Colors.amber.shade200,
                  child: Text('Bo', style: context.textTheme.s10w500),
                ),
                const HorizontalSpacing(6),
                Text(value, style: context.textTheme.s12w500),
              ],
            )
          else
            Text(value, style: context.textTheme.s12w500),
        ],
      ),
    );
  }

  // Message Tab
  Widget _buildMessageTab() {
    return SingleChildScrollView(
      child: Text(
        'Dear Balogun Oluwatosin Omolola, your request to add a new account on the Noble Merry account dashboard was successful and ₦5,600 deducted from your primary account wallet. Thank you for choosing Noble Merry Ventures!!',
        style: context.textTheme.s12w400.copyWith(height: 1.5),
      ),
    );
  }

  // Report Tab
  Widget _buildReportTab() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('All Status', style: context.textTheme.s12w500),
                const Icon(Icons.keyboard_arrow_down, size: 16),
              ],
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_outlined,
                  size: 14, color: Colors.black),
              label: Text('Export',
                  style:
                      context.textTheme.s10w500.copyWith(color: Colors.black)),
            ),
          ],
        ),
        const VerticalSpacing(12),
        Expanded(
          child: ListView.separated(
            itemCount: 4,
            separatorBuilder: (_, __) => const VerticalSpacing(10),
            itemBuilder: (context, index) {
              final isFailed = index == 1;
              return Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: Colors.amber.shade200,
                      child: Text('Bo', style: context.textTheme.s10w500),
                    ),
                    const HorizontalSpacing(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DELIVERY ID: 1234489YUZ',
                              style: context.textTheme.s10w400
                                  .copyWith(color: Colors.grey)),
                          Text('Boluwatife Ogundiji',
                              style: context.textTheme.s12w600),
                          Text('080123784011',
                              style: context.textTheme.s10w400
                                  .copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Awaiting delivery',
                            style: context.textTheme.s10w400
                                .copyWith(color: Colors.grey)),
                        const VerticalSpacing(4),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: isFailed
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            isFailed ? 'Undelivered' : 'Delivered',
                            style: context.textTheme.s10w400.copyWith(
                              color: isFailed ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
