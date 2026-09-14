import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/history/presentation/data/model/sms_history_item.dart';
import 'package:pmcsms/presentation/features/history/presentation/provider/history_providers.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/custom_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class MessageDetailsView extends ConsumerStatefulWidget {
  const MessageDetailsView({super.key, required this.smsId});

  static const String routeName = '/messageDetails';

  final int smsId;

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

  Future<void> _resend() async {
    final notifier = ref.read(resendSmsProvider.notifier);
    await notifier.resend(widget.smsId);
    if (!mounted) return;

    final result = ref.read(resendSmsProvider);
    final succeeded = result.lastSucceeded ?? false;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: succeeded ? Colors.green : Colors.red,
        content: Text(
          result.message?.isNotEmpty == true
              ? result.message!
              : (succeeded ? 'Message resent' : 'Unable to resend message'),
        ),
      ),
    );

    if (succeeded) {
      // The message row (status/date/fee) may have changed, refetch it.
      ref.invalidate(messageDetailsProvider(widget.smsId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(messageDetailsProvider(widget.smsId));
    final resendState = ref.watch(resendSmsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Message Details'),
      body: SafeArea(
        child: detailsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Could not load this message.',
                  style: context.textTheme.s12w500.copyWith(color: Colors.grey),
                ),
                const VerticalSpacing(12),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(messageDetailsProvider(widget.smsId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (response) {
            final item = response.data;
            if (!response.status || item == null) {
              return Center(
                child: Text(
                  response.serverMessage.isNotEmpty
                      ? response.serverMessage
                      : 'Message not found',
                  style: context.textTheme.s12w500.copyWith(color: Colors.grey),
                ),
              );
            }

            return Padding(
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
                          'Message sent to',
                          style: context.textTheme.s10w400
                              .copyWith(color: Colors.grey),
                        ),
                        const VerticalSpacing(6),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10.r,
                              backgroundColor: Colors.amber.shade200,
                              child: Text(
                                item.senderId.isNotEmpty
                                    ? item.senderId.substring(
                                        0, item.senderId.length >= 2 ? 2 : 1)
                                    : '?',
                                style: context.textTheme.s10w500,
                              ),
                            ),
                            const HorizontalSpacing(8),
                            Expanded(
                              child: Text(
                                item.recipientCount > 1
                                    ? '${item.primaryRecipient} & ${item.recipientCount - 1} other${item.recipientCount - 1 == 1 ? '' : 's'}'
                                    : item.primaryRecipient,
                                style: context.textTheme.s12w600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpacing(12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed:
                                    resendState.isLoading ? null : _resend,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFF9EA3FF)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                ),
                                child: resendState.isLoading
                                    ? SizedBox(
                                        height: 14.r,
                                        width: 14.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF9EA3FF),
                                        ),
                                      )
                                    : Text(
                                        'Resend message',
                                        style: context.textTheme.s12w500
                                            .copyWith(
                                                color: const Color(0xFF9EA3FF)),
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
                        _buildDetailsTab(item),
                        _buildMessageTab(item),
                        _buildReportTab(item),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Details Tab
  Widget _buildDetailsTab(SmsHistoryItem item) {
    return Column(
      children: [
        _buildDetailRow('Sender ID', item.senderId),
        _buildDetailRow('Status', item.displayStatus, isBadge: true),
        _buildDetailRow('Date', item.createdAt),
        _buildDetailRow('Recipient', item.primaryRecipient, showAvatar: true),
        _buildDetailRow('Fee', '${item.totalAmount} Units'),
      ],
    );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    bool isBadge = false,
    bool showAvatar = false,
  }) {
    Color badgeBg = Colors.green.shade50;
    Color badgeFg = Colors.green;
    if (isBadge) {
      switch (value) {
        case 'Failed':
          badgeBg = Colors.red.shade50;
          badgeFg = Colors.red;
          break;
        case 'Pending':
          badgeBg = Colors.orange.shade50;
          badgeFg = Colors.orange;
          break;
      }
    }

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
                color: badgeBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(value,
                  style: context.textTheme.s10w400.copyWith(color: badgeFg)),
            )
          else if (showAvatar)
            Row(
              children: [
                CircleAvatar(
                  radius: 10.r,
                  backgroundColor: Colors.amber.shade200,
                  child: Text(
                    value.isNotEmpty
                        ? value.substring(0, value.length >= 2 ? 2 : 1)
                        : '?',
                    style: context.textTheme.s10w500,
                  ),
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
  Widget _buildMessageTab(SmsHistoryItem item) {
    return SingleChildScrollView(
      child: Text(
        item.message,
        style: context.textTheme.s12w400.copyWith(height: 1.5),
      ),
    );
  }

  // Report Tab — per-recipient delivery status.
  // Note: the backend currently only returns a single `status` and a
  // comma-separated `recipients` string for a message, not a per-recipient
  // delivery report. Until a dedicated endpoint exists, this renders one
  // row per recipient using the message's overall status.
  Widget _buildReportTab(SmsHistoryItem item) {
    final recipients =
        item.recipientList.isEmpty ? [item.recipients] : item.recipientList;

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
            itemCount: recipients.length,
            separatorBuilder: (_, __) => const VerticalSpacing(10),
            itemBuilder: (context, index) {
              final recipient = recipients[index];
              final status = item.displayStatus;
              final isFailed = status == 'Failed';

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
                      child: Text('${item.smsId}',
                          style: context.textTheme.s10w500),
                    ),
                    const HorizontalSpacing(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SMS ID: ${item.smsId}',
                              style: context.textTheme.s10w400
                                  .copyWith(color: Colors.grey)),
                          Text(recipient, style: context.textTheme.s12w600),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                            status,
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
