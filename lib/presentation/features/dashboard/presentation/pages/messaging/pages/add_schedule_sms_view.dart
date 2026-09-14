import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/extensions/overlay_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/model/create_schedule_sms_request.dart';
import 'package:pmcsms/presentation/features/dashboard/presentation/pages/messaging/pages/scheduled_sms/data/notifier/create_scheduled_sms_notifier.dart';
import 'package:pmcsms/presentation/features/senderid/presentation/notifier/sender_id_list_notifier.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

enum _SendOption { now, schedule }

class AddScheduleSmsView extends ConsumerStatefulWidget {
  const AddScheduleSmsView({super.key});
  static const String routeName = '/addScheduleSms';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddScheduleSmsViewState();
}

class _AddScheduleSmsViewState extends ConsumerState<AddScheduleSmsView> {
  final _recipientController = TextEditingController();
  final _messageController = TextEditingController();

  String? _selectedSenderId;
  _SendOption _sendOption = _SendOption.schedule;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _repeat = 'Never';

  static const List<String> _repeatOptions = [
    'Never',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  @override
  void initState() {
    super.initState();
    for (final c in [_recipientController, _messageController]) {
      c.addListener(() => setState(() {}));
    }
    // Reuse the same sender-ID fetch used by the Sender ID module —
    // scheduled SMS is a `pm_sms` action, so it needs 'sms' sender IDs,
    // not 'voice' or 'email'.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(senderIdListNotifier.notifier).getSenderIds(
            service: 'sms',
            onError: (error) => context.showError(message: error),
          );
    });
  }

  @override
  void dispose() {
    _recipientController.dispose();
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

  /// API expects "yyyy-MM-dd HH:mm:ss" per the sample:
  /// "schedule_date": "2026-08-10 09:00:00".
  String _toApiDateTime(DateTime date, TimeOfDay time) {
    final dt =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:00';
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    DateTime temp = _selectedDate ?? now;
    if (temp.isBefore(now)) temp = now;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: now,
                  initialDateTime: temp,
                  onDateTimeChanged: (value) => temp = value,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        );
      },
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
      builder: (context) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                    2024,
                    1,
                    1,
                    temp.hour,
                    temp.minute,
                  ),
                  onDateTimeChanged: (value) =>
                      temp = TimeOfDay(hour: value.hour, minute: value.minute),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        );
      },
    );
  }

  Future<void> _pickRepeat() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _repeatOptions
                .map(
                  (option) => ListTile(
                    title: Text(option),
                    trailing: option == _repeat
                        ? const Icon(Icons.check, color: AppColors.black)
                        : null,
                    onTap: () {
                      setState(() => _repeat = option);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  bool get _canSubmit {
    final hasRequiredFields = _selectedSenderId != null &&
        _recipientController.text.trim().isNotEmpty &&
        _messageController.text.trim().isNotEmpty;
    if (!hasRequiredFields) return false;
    if (_sendOption == _SendOption.now) return true;
    return _selectedDate != null && _selectedTime != null;
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;

    if (_sendOption == _SendOption.now) {
      // No send-now endpoint exists yet (only create_schedule_sms, which
      // requires a future schedule_date). Block rather than silently no-op.
      context.showError(
        message:
            'Sending immediately isn\'t available yet — please schedule a time.',
      );
      return;
    }

    // _repeat is intentionally NOT sent — create_schedule_sms has no
    // recurrence field. Recurring schedules aren't supported server-side yet.
    final scheduleDate = _toApiDateTime(_selectedDate!, _selectedTime!);

    ref.read(createScheduledSmsNotifier.notifier).createScheduledSms(
          data: CreateScheduleSmsRequest(
            senderId: _selectedSenderId!,
            message: _messageController.text.trim(),
            recipient: _recipientController.text.trim(),
            scheduleDate: scheduleDate,
          ),
          onError: (error) {
            context.showError(message: error);
          },
          onSuccess: (message) {
            context.showSuccess(message: message);
            Navigator.pop(context);
          },
        );
  }

  Widget _fieldBox({
    required String value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
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
            Expanded(
              child: Text(
                value,
                style: context.textTheme.s12w400.copyWith(
                  color: value.isEmpty
                      ? AppColors.black.withOpacity(0.4)
                      : AppColors.black,
                ),
              ),
            ),
            Icon(icon, size: 18, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  InputDecoration _textFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: context.textTheme.s12w400
          .copyWith(color: AppColors.black.withOpacity(0.4)),
      filled: true,
      fillColor: AppColors.primaryF5F7F9,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildSenderIdDropdown() {
    final listState = ref.watch(senderIdListNotifier);
    final senderNames = listState.items.map((i) => i.senderId).toList();

    if (listState.isLoading && senderNames.isEmpty) {
      return Container(
        height: 48,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.primaryF5F7F9,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue:
          senderNames.contains(_selectedSenderId) ? _selectedSenderId : null,
      isExpanded: true,
      decoration: _textFieldDecoration(
        senderNames.isEmpty ? 'No sender IDs available' : 'Select a sender ID',
      ),
      items: senderNames
          .map((id) => DropdownMenuItem(value: id, child: Text(id)))
          .toList(),
      onChanged: senderNames.isEmpty
          ? null
          : (value) => setState(() => _selectedSenderId = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(createScheduledSmsNotifier.select((v) => v.isLoading));

    return Scaffold(
      appBar: CustomAppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.black),
        ),
        title: 'Schedule message',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sender ID', style: context.textTheme.s12w400),
              const VerticalSpacing(6),
              _buildSenderIdDropdown(),
              const VerticalSpacing(16),
              Text('Recipient', style: context.textTheme.s12w400),
              const VerticalSpacing(6),
              TextField(
                controller: _recipientController,
                keyboardType: TextInputType.phone,
                decoration: _textFieldDecoration('e.g 08012345678'),
              ),
              const VerticalSpacing(16),
              Text('Message', style: context.textTheme.s12w400),
              const VerticalSpacing(6),
              TextField(
                controller: _messageController,
                maxLines: 4,
                decoration: _textFieldDecoration('Type message here'),
              ),
              const VerticalSpacing(20),
              RadioListTile<_SendOption>(
                contentPadding: EdgeInsets.zero,
                value: _SendOption.now,
                groupValue: _sendOption,
                activeColor: AppColors.black,
                title: Text('New', style: context.textTheme.s12w400),
                onChanged: (value) => setState(() => _sendOption = value!),
              ),
              RadioListTile<_SendOption>(
                contentPadding: EdgeInsets.zero,
                value: _SendOption.schedule,
                groupValue: _sendOption,
                activeColor: AppColors.black,
                title: Text(
                  'Schedule message',
                  style: context.textTheme.s12w400
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Select a preferred time to have this message delivered',
                  style: context.textTheme.s12w400
                      .copyWith(color: AppColors.black.withOpacity(0.5)),
                ),
                onChanged: (value) => setState(() => _sendOption = value!),
              ),
              if (_sendOption == _SendOption.schedule) ...[
                const VerticalSpacing(12),
                Text('Date', style: context.textTheme.s12w400),
                const VerticalSpacing(6),
                _fieldBox(
                  value: _selectedDate == null
                      ? 'dd/mm/yyyy'
                      : _formatDate(_selectedDate!),
                  onTap: _pickDate,
                  icon: Icons.calendar_today_outlined,
                ),
                const VerticalSpacing(16),
                Text('Time', style: context.textTheme.s12w400),
                const VerticalSpacing(6),
                _fieldBox(
                  value: _selectedTime == null
                      ? 'hh:mm'
                      : _formatTime(_selectedTime!),
                  onTap: _pickTime,
                  icon: Icons.access_time,
                ),
                const VerticalSpacing(16),
                Text('Repeat', style: context.textTheme.s12w400),
                const VerticalSpacing(6),
                GestureDetector(
                  onTap: _pickRepeat,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_repeat, style: context.textTheme.s12w400),
                      const Icon(Icons.chevron_right, color: AppColors.black),
                    ],
                  ),
                ),
                // Note: _repeat is not currently sent to the server —
                // create_schedule_sms has no recurrence field yet.
              ],
              const VerticalSpacing(30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canSubmit
                        ? AppColors.black
                        : AppColors.black.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: (_canSubmit && !isLoading) ? _submit : null,
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          _sendOption == _SendOption.now
                              ? 'Send message'
                              : 'Schedule message',
                          style: const TextStyle(color: AppColors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
