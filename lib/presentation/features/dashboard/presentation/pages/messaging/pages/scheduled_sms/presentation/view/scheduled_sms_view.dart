import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/add_schedule_sms_view.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

/// Local placeholder model — replace with the real scheduled-message
/// model once the notifier/endpoint exists.
class ScheduledMessage {
  const ScheduledMessage({
    required this.title,
    required this.preview,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
  });

  final String title;
  final String preview;
  final String scheduledDate;
  final String scheduledTime;
  final String status;
}

class ScheduledSmsView extends ConsumerStatefulWidget {
  const ScheduledSmsView({super.key});
  static const String routeName = '/scheduledSms';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduledSmsViewState();
}

class _ScheduledSmsViewState extends ConsumerState<ScheduledSmsView> {
  final TextEditingController _searchController = TextEditingController();

  // TODO: replace with `ref.watch(getScheduledSmsNotifier.select((v) => v.data?.data?.scheduled ?? []))`
  final List<ScheduledMessage> _scheduledMessages = const [
    ScheduledMessage(
      title: 'Holidays',
      preview:
          'Wishing each and everyone a happy holiday, I am extending my warm wishes to you and...',
      scheduledDate: '23-11-2026',
      scheduledTime: '08:00 AM',
      status: 'Pending',
    ),
    ScheduledMessage(
      title: 'Emergency meeting',
      preview:
          'Please, be informed that by 8:00 pm on the 25th of november. There will be an emergency meeting with the CEO at the mini hall...',
      scheduledDate: '25-11-2026',
      scheduledTime: '08:00 PM',
      status: 'Pending',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // TODO: fetch scheduled messages
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await ref.read(getScheduledSmsNotifier.notifier).getScheduledSms();
    // });
  }

  List<ScheduledMessage> get _filteredMessages {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _scheduledMessages;
    return _scheduledMessages
        .where((m) => m.title.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _filteredMessages;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Scheduled SMS',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset('assets/icons/clock.svg'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: context.textTheme.s12w400
                      .copyWith(color: AppColors.black.withOpacity(0.4)),
                  prefixIcon: const Icon(Icons.search, color: AppColors.black),
                  filled: true,
                  fillColor: AppColors.primaryF5F7F9,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/clock.svg',
                            width: 40,
                            height: 40,
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No scheduled messages',
                            style: context.textTheme.s12w400
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: messages.length,
                      separatorBuilder: (_, __) => const VerticalSpacing(4),
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _ScheduledMessageTile(message: message);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddScheduleSmsView(),
            ),
          );
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}

class _ScheduledMessageTile extends StatelessWidget {
  const _ScheduledMessageTile({required this.message});

  final ScheduledMessage message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: navigate to schedule detail / edit screen.
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    message.title,
                    style: context.textTheme.s12w400
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    message.status,
                    style: const TextStyle(color: Colors.orange, fontSize: 11),
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert,
                      size: 18, color: AppColors.black),
                  onSelected: (action) {
                    // TODO: handle 'edit' / 'send_now' / 'cancel'
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'send_now', child: Text('Send now')),
                    PopupMenuItem(
                        value: 'cancel', child: Text('Cancel schedule')),
                  ],
                ),
              ],
            ),
            const VerticalSpacing(4),
            Text(
              message.preview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.s12w400
                  .copyWith(color: AppColors.black.withOpacity(0.5)),
            ),
            const VerticalSpacing(8),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/clock.svg',
                  width: 13,
                  height: 13,
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${message.scheduledDate} · ${message.scheduledTime}',
                  style: context.textTheme.s12w400
                      .copyWith(color: AppColors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
