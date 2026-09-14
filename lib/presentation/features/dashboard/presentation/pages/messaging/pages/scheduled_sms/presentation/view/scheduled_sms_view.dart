// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pmcsms/core/extensions/overlay_extension.dart';
// import 'package:pmcsms/core/extensions/text_theme_extension.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/core/utils/enums.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/add_schedule_sms_view.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/delete_scheduled_message_request.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/delete_scheduled_sms_notifier.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/get_scheduled_sms_notifier.dart';
// import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/schedule_sms_response.dart';
// import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';

// class ScheduledSmsView extends ConsumerStatefulWidget {
//   const ScheduledSmsView({super.key});
//   static const String routeName = '/scheduledSms';

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ScheduledSmsViewState();
// }

// class _ScheduledSmsViewState extends ConsumerState<ScheduledSmsView> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await ref
//           .read(getScheduledSmsNotifier.notifier)
//           .getScheduledSms(start: 1, length: 20);
//     });
//   }

//   List<ScheduledSmsItem> _applyFilter(List<ScheduledSmsItem> items) {
//     final query = _searchController.text.trim().toLowerCase();
//     if (query.isEmpty) return items;
//     return items
//         .where((m) => (m.message ?? '').toLowerCase().contains(query))
//         .toList();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _refresh() {
//     ref
//         .read(getScheduledSmsNotifier.notifier)
//         .getScheduledSms(start: 1, length: 20);
//   }

//   void _deleteSchedule(ScheduledSmsItem item) {
//     if (item.scheduleId == null) return;
//     ref.read(deleteScheduledSmsNotifier.notifier).deleteScheduledSms(
//           data: DeleteScheduledMessageRequest(scheduleId: item.scheduleId!),
//           onError: (error) => context.showError(message: error),
//           onSuccess: (message) {
//             context.showSuccess(message: message);
//             _refresh();
//           },
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final listState = ref.watch(getScheduledSmsNotifier);
//     final isLoading = listState.state == LoadState.loading;
//     final allMessages = listState.data?.data ?? <ScheduledSmsItem>[];
//     final messages = _applyFilter(allMessages);

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Scheduled SMS',
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: SvgPicture.asset('assets/icons/clock.svg'),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: (_) => setState(() {}),
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: context.textTheme.s12w400
//                       .copyWith(color: AppColors.black.withOpacity(0.4)),
//                   prefixIcon: const Icon(Icons.search, color: AppColors.black),
//                   filled: true,
//                   fillColor: AppColors.primaryF5F7F9,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: isLoading && allMessages.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : messages.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SvgPicture.asset(
//                                 'assets/icons/clock.svg',
//                                 width: 40,
//                                 height: 40,
//                                 colorFilter: const ColorFilter.mode(
//                                   Colors.grey,
//                                   BlendMode.srcIn,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 'No scheduled messages',
//                                 style: context.textTheme.s12w400
//                                     .copyWith(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         )
//                       : RefreshIndicator(
//                           onRefresh: () => ref
//                               .read(getScheduledSmsNotifier.notifier)
//                               .getScheduledSms(start: 1, length: 20),
//                           child: ListView.separated(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             itemCount: messages.length,
//                             separatorBuilder: (_, __) =>
//                                 const VerticalSpacing(4),
//                             itemBuilder: (context, index) {
//                               final message = messages[index];
//                               return _ScheduledMessageTile(
//                                 message: message,
//                                 onDelete: () => _deleteSchedule(message),
//                               );
//                             },
//                           ),
//                         ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.primaryColor,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const AddScheduleSmsView(),
//             ),
//           ).then((_) {
//             // Refresh in case a new schedule was just created.
//             _refresh();
//           });
//         },
//         child: const Icon(Icons.add, color: AppColors.white),
//       ),
//     );
//   }
// }

// class _ScheduledMessageTile extends StatelessWidget {
//   const _ScheduledMessageTile({
//     required this.message,
//     required this.onDelete,
//   });

//   final ScheduledSmsItem message;
//   final VoidCallback onDelete;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // TODO: navigate to schedule detail / edit screen once available.
//       },
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     message.senderId ?? '',
//                     style: context.textTheme.s12w400
//                         .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
//                   ),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     message.status ?? 'Pending',
//                     style: const TextStyle(color: Colors.orange, fontSize: 11),
//                   ),
//                 ),
//                 PopupMenuButton<String>(
//                   padding: EdgeInsets.zero,
//                   icon: const Icon(Icons.more_vert,
//                       size: 18, color: AppColors.black),
//                   onSelected: (action) {
//                     switch (action) {
//                       case 'cancel':
//                         onDelete();
//                         break;
//                       case 'edit':
//                       case 'send_now':
//                         // TODO: no edit screen or send-now endpoint provided yet.
//                         break;
//                     }
//                   },
//                   itemBuilder: (context) => const [
//                     PopupMenuItem(value: 'edit', child: Text('Edit')),
//                     PopupMenuItem(value: 'send_now', child: Text('Send now')),
//                     PopupMenuItem(
//                         value: 'cancel', child: Text('Cancel schedule')),
//                   ],
//                 ),
//               ],
//             ),
//             const VerticalSpacing(4),
//             Text(
//               message.message ?? '',
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: context.textTheme.s12w400
//                   .copyWith(color: AppColors.black.withOpacity(0.5)),
//             ),
//             const VerticalSpacing(8),
//             Row(
//               children: [
//                 SvgPicture.asset(
//                   'assets/icons/clock.svg',
//                   width: 13,
//                   height: 13,
//                   colorFilter: const ColorFilter.mode(
//                     AppColors.black,
//                     BlendMode.srcIn,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   message.scheduleDate ?? '',
//                   style: context.textTheme.s12w400
//                       .copyWith(color: AppColors.black.withOpacity(0.6)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/core/utils/enums.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/add_schedule_sms_view.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/delete_scheduled_message_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/update_scheduled_message_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/delete_scheduled_sms_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/get_scheduled_sms_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/update_scheduled_sms_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/view_scheduled_sms_notifier.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/schedule_sms_response.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

class ScheduledSmsView extends ConsumerStatefulWidget {
  const ScheduledSmsView({super.key});
  static const String routeName = '/scheduledSms';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduledSmsViewState();
}

class _ScheduledSmsViewState extends ConsumerState<ScheduledSmsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(getScheduledSmsNotifier.notifier)
          .getScheduledSms(start: 1, length: 20);
    });
  }

  List<ScheduledSmsItem> _applyFilter(List<ScheduledSmsItem> items) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items
        .where((m) => (m.message ?? '').toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    ref
        .read(getScheduledSmsNotifier.notifier)
        .getScheduledSms(start: 1, length: 20);
  }

  void _deleteSchedule(ScheduledSmsItem item) {
    if (item.scheduleId == null) return;
    ref.read(deleteScheduledSmsNotifier.notifier).deleteScheduledSms(
          data: DeleteScheduledMessageRequest(scheduleId: item.scheduleId!),
          onError: (error) => context.showError(message: error),
          onSuccess: (message) {
            context.showSuccess(message: message);
            _refresh();
          },
        );
  }

  /// Fetches the full record via view_scheduled_message, then hands it to
  /// [onLoaded]. Shows a small blocking spinner while the request is in
  /// flight since this is a one-off fetch, not a watched list.
  Future<void> _loadDetail({
    required int scheduleId,
    required void Function(ScheduledSmsItem item) onLoaded,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    await ref.read(viewScheduledSmsNotifier.notifier).viewScheduledSms(
          scheduleId: scheduleId,
          onError: (error) {
            Navigator.pop(context); // dismiss spinner
            context.showError(message: error);
          },
          onSuccess: (item) {
            Navigator.pop(context); // dismiss spinner
            onLoaded(item);
          },
        );
  }

  void _viewSchedule(ScheduledSmsItem listItem) {
    if (listItem.scheduleId == null) return;
    _loadDetail(
      scheduleId: listItem.scheduleId!,
      onLoaded: _showDetailSheet,
    );
  }

  void _editSchedule(ScheduledSmsItem listItem) {
    if (listItem.scheduleId == null) return;
    _loadDetail(
      scheduleId: listItem.scheduleId!,
      onLoaded: (item) => _showEditSheet(item),
    );
  }

  void _showDetailSheet(ScheduledSmsItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.senderId ?? '',
                  style: context.textTheme.s12w400
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const VerticalSpacing(4),
                Text(
                  item.status ?? 'Pending',
                  style: const TextStyle(color: Colors.orange, fontSize: 12),
                ),
                const VerticalSpacing(16),
                Text('Recipient', style: context.textTheme.s12w400),
                const VerticalSpacing(4),
                Text(item.recipient ?? '—', style: context.textTheme.s12w400),
                const VerticalSpacing(16),
                Text('Message', style: context.textTheme.s12w400),
                const VerticalSpacing(4),
                Text(item.message ?? '', style: context.textTheme.s12w400),
                const VerticalSpacing(16),
                Text('Scheduled for', style: context.textTheme.s12w400),
                const VerticalSpacing(4),
                Text(item.scheduleDate ?? '—',
                    style: context.textTheme.s12w400),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditSheet(ScheduledSmsItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _EditScheduleSheet(
        item: item,
        onSaved: _refresh,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(getScheduledSmsNotifier);
    final isLoading = listState.state == LoadState.loading;
    final allMessages = listState.data?.data ?? <ScheduledSmsItem>[];
    final messages = _applyFilter(allMessages);

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
              child: isLoading && allMessages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
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
                      : RefreshIndicator(
                          onRefresh: () => ref
                              .read(getScheduledSmsNotifier.notifier)
                              .getScheduledSms(start: 1, length: 20),
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: messages.length,
                            separatorBuilder: (_, __) =>
                                const VerticalSpacing(4),
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return _ScheduledMessageTile(
                                message: message,
                                onTap: () => _viewSchedule(message),
                                onEdit: () => _editSchedule(message),
                                onDelete: () => _deleteSchedule(message),
                              );
                            },
                          ),
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
          ).then((_) {
            // Refresh in case a new schedule was just created.
            _refresh();
          });
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}

class _ScheduledMessageTile extends StatelessWidget {
  const _ScheduledMessageTile({
    required this.message,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final ScheduledSmsItem message;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                    message.senderId ?? '',
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
                    message.status ?? 'Pending',
                    style: const TextStyle(color: Colors.orange, fontSize: 11),
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert,
                      size: 18, color: AppColors.black),
                  onSelected: (action) {
                    switch (action) {
                      case 'cancel':
                        onDelete();
                        break;
                      case 'edit':
                        onEdit();
                        break;
                      case 'send_now':
                        // No send-now endpoint exists yet — only
                        // create/update/delete/view are available.
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(
                      value: 'send_now',
                      enabled: false, // TODO: enable once endpoint exists
                      child: Text('Send now'),
                    ),
                    PopupMenuItem(
                        value: 'cancel', child: Text('Cancel schedule')),
                  ],
                ),
              ],
            ),
            const VerticalSpacing(4),
            Text(
              message.message ?? '',
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
                  message.scheduleDate ?? '',
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

/// Edit sheet for an existing scheduled message. Only `message` and
/// `schedule_date` are editable — that's all update_scheduled_message
/// accepts; sender_id/recipient aren't part of that request.
class _EditScheduleSheet extends ConsumerStatefulWidget {
  const _EditScheduleSheet({required this.item, required this.onSaved});

  final ScheduledSmsItem item;
  final VoidCallback onSaved;

  @override
  ConsumerState<_EditScheduleSheet> createState() => _EditScheduleSheetState();
}

class _EditScheduleSheetState extends ConsumerState<_EditScheduleSheet> {
  late final TextEditingController _messageController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.item.message);
    final parsed = DateTime.tryParse(widget.item.scheduleDate ?? '');
    if (parsed != null) {
      _selectedDate = DateTime(parsed.year, parsed.month, parsed.day);
      _selectedTime = TimeOfDay(hour: parsed.hour, minute: parsed.minute);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  /// "yyyy-MM-dd HH:mm:ss" — same format update_scheduled_message expects.
  String _toApiDateTime(DateTime date, TimeOfDay time) {
    final dt =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:00';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    DateTime temp = _selectedDate ?? now;
    if (temp.isBefore(now)) temp = now;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: 280,
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                minimumDate: now,
                initialDateTime: temp,
                onDateTimeChanged: (value) => temp = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black),
                  onPressed: () {
                    setState(() => _selectedDate = temp);
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    TimeOfDay temp = _selectedTime ?? TimeOfDay.now();
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: 280,
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(2024, 1, 1, temp.hour, temp.minute),
                onDateTimeChanged: (value) =>
                    temp = TimeOfDay(hour: value.hour, minute: value.minute),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black),
                  onPressed: () {
                    setState(() => _selectedTime = temp);
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canSave =>
      widget.item.scheduleId != null &&
      widget.item.senderId != null &&
      _messageController.text.trim().isNotEmpty &&
      _selectedDate != null &&
      _selectedTime != null;

  void _save() {
    if (!_canSave) return;
    ref.read(updateScheduledSmsNotifier.notifier).updateScheduledSms(
          data: UpdateScheduledMessageRequest(
            scheduleId: widget.item.scheduleId!,
            senderId: widget.item.senderId!,
            message: _messageController.text.trim(),
            scheduleDate: _toApiDateTime(_selectedDate!, _selectedTime!),
          ),
          onError: (error) => context.showError(message: error),
          onSuccess: (message) {
            Navigator.pop(context);
            context.showSuccess(message: message);
            widget.onSaved();
          },
        );
  }

  InputDecoration _fieldDecoration() => InputDecoration(
        filled: true,
        fillColor: AppColors.primaryF5F7F9,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      );

  Widget _fieldBox(String value, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryF5F7F9, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: Text(value, style: context.textTheme.s12w400)),
            Icon(icon, size: 18, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(updateScheduledSmsNotifier.select((v) => v.isLoading));

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit schedule',
                style: context.textTheme.s12w400
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
            const VerticalSpacing(16),
            Text('Message', style: context.textTheme.s12w400),
            const VerticalSpacing(6),
            TextField(
              controller: _messageController,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: _fieldDecoration(),
            ),
            const VerticalSpacing(16),
            Text('Date', style: context.textTheme.s12w400),
            const VerticalSpacing(6),
            _fieldBox(
              _selectedDate == null
                  ? 'dd/mm/yyyy'
                  : _formatDate(_selectedDate!),
              _pickDate,
              Icons.calendar_today_outlined,
            ),
            const VerticalSpacing(16),
            Text('Time', style: context.textTheme.s12w400),
            const VerticalSpacing(6),
            _fieldBox(
              _selectedTime == null ? 'hh:mm' : _formatTime(_selectedTime!),
              _pickTime,
              Icons.access_time,
            ),
            const VerticalSpacing(24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canSave
                      ? AppColors.black
                      : AppColors.black.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: (_canSave && !isLoading) ? _save : null,
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Text('Save changes',
                        style: TextStyle(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
