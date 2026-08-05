import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';

enum _SendOption { now, schedule }

class AddScheduleSmsView extends ConsumerStatefulWidget {
  const AddScheduleSmsView({super.key, this.messageDraft});
  static const String routeName = '/addScheduleSms';

  /// Whatever payload was built on the previous compose step
  /// (sender ID, recipients, message body, etc.). Passed through
  /// here so it can be submitted together with the schedule fields.
  final Object? messageDraft;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddScheduleSmsViewState();
}

class _AddScheduleSmsViewState extends ConsumerState<AddScheduleSmsView> {
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
    if (_sendOption == _SendOption.now) return true;
    return _selectedDate != null && _selectedTime != null;
  }

  void _submit() {
    if (!_canSubmit) return;
    if (_sendOption == _SendOption.now) {
      // TODO: submit widget.messageDraft immediately via the send-now notifier.
    } else {
      // TODO: submit widget.messageDraft + _selectedDate + _selectedTime + _repeat
      // via the schedule-message notifier, e.g.:
      // ref.read(scheduleSmsNotifier.notifier).scheduleMessage(
      //   draft: widget.messageDraft,
      //   date: _selectedDate!,
      //   time: _selectedTime!,
      //   repeat: _repeat,
      // );
    }
    Navigator.pop(context);
  }

  Widget _fieldBox({
    required String label,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.black),
        ),
        title: 'Schedule message',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  label: 'Date',
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
                  label: 'Time',
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
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canSubmit
                        ? AppColors.black
                        : AppColors.black.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _canSubmit ? _submit : null,
                  child: Text(
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
