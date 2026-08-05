import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';

class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({
    super.key,
    required this.selectedMonth,
    required this.selectedStatus,
    required this.onMonthChanged,
    required this.onStatusChanged,
  });

  final DateTime selectedMonth;
  final String selectedStatus;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<String> onStatusChanged;

  static const List<String> statusOptions = [
    'All Status',
    'Successful',
    'Pending',
    'Failed',
  ];

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  Future<void> _openMonthPicker(BuildContext context) async {
    DateTime tempDate = selectedMonth;
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
                  initialDateTime: selectedMonth,
                  onDateTimeChanged: (value) => tempDate = value,
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
                      onMonthChanged(tempDate);
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

  Widget _dropdownLabel(BuildContext context, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: context.textTheme.s12w400),
        const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.black),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _openMonthPicker(context),
            child:
                _dropdownLabel(context, _monthNames[selectedMonth.month - 1]),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            offset: const Offset(0, 36),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            initialValue: selectedStatus,
            onSelected: onStatusChanged,
            itemBuilder: (context) => statusOptions
                .map(
                  (status) => PopupMenuItem<String>(
                    value: status,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(status, style: context.textTheme.s12w400),
                        if (status == selectedStatus)
                          const Icon(Icons.check,
                              size: 18, color: AppColors.black),
                      ],
                    ),
                  ),
                )
                .toList(),
            child: _dropdownLabel(context, selectedStatus),
          ),
        ],
      ),
    );
  }
}
