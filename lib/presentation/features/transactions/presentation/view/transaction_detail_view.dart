import 'package:flutter/material.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/transactions/utils/receipt_generator.dart';
import 'package:pmcsms/presentation/general_widgets/custom_app_bar.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';
import 'package:printing/printing.dart';

class TransactionDetailView extends StatelessWidget {
  const TransactionDetailView({
    super.key,
    required this.title,
    required this.amount,
    required this.isCredit,
    required this.categoryLabel,
    required this.transactionId,
    required this.status,
    required this.transactionDate,
    required this.category,
    this.counterpartyLabel,
    this.counterpartyName,
    this.extraLabel,
    this.extraValue,
    this.showActions = true,
  });

  static const String routeName = '/transactionDetailView';

  final String title;
  final String amount;
  final bool isCredit;
  final String categoryLabel;
  final String transactionId;
  final String status;
  final String transactionDate;
  final String category;
  final String? counterpartyLabel;
  final String? counterpartyName;
  final String? extraLabel;
  final String? extraValue;
  final bool showActions;

  Future<void> _generateReceipt(BuildContext context) async {
    try {
      final bytes = await ReceiptGenerator.build(
        title: title,
        amount: amount,
        isCredit: isCredit,
        categoryLabel: categoryLabel,
        transactionId: transactionId,
        status: status,
        transactionDate: transactionDate,
        category: category,
        counterpartyLabel: counterpartyLabel,
        counterpartyName: counterpartyName,
        extraLabel: extraLabel,
        extraValue: extraValue,
      );

      await Printing.sharePdf(
        bytes: bytes,
        filename: 'receipt_$transactionId.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not generate receipt: $e')),
        );
      }
    }
  }

  Widget _row(BuildContext context, String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.s12w400
                .copyWith(color: AppColors.black.withOpacity(0.5)),
          ),
          value,
        ],
      ),
    );
  }

  Widget _avatar(String name) {
    final parts = name.trim().split(' ').where((e) => e.isNotEmpty).toList();
    final initials = parts.isEmpty
        ? '?'
        : parts.take(2).map((e) => e[0]).join().toUpperCase();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.primaryF5F7F9,
          child: Text(initials,
              style: const TextStyle(fontSize: 10, color: AppColors.black)),
        ),
        const SizedBox(width: 8),
        Text(name),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.black),
        ),
        title: 'Transaction Details',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryF5F7F9,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.s12w400),
                    const VerticalSpacing(8),
                    Text(
                      '${isCredit ? '+' : '-'}$amount',
                      style: context.textTheme.s12w400
                          .copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    const VerticalSpacing(4),
                    Text(
                      categoryLabel,
                      style: context.textTheme.s12w400
                          .copyWith(color: AppColors.black.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
              const VerticalSpacing(20),
              _row(context, 'Transaction ID', Text(transactionId)),
              _row(
                context,
                'Status',
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status,
                      style:
                          const TextStyle(color: Colors.green, fontSize: 12)),
                ),
              ),
              _row(context, 'Transaction Date', Text(transactionDate)),
              if (counterpartyLabel != null && counterpartyName != null)
                _row(context, counterpartyLabel!, _avatar(counterpartyName!)),
              if (extraLabel != null && extraValue != null)
                _row(context, extraLabel!, Text(extraValue!)),
              _row(context, 'Category', Text(category)),
              const Spacer(),
              if (showActions)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Report an issue'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black),
                        onPressed: () => _generateReceipt(context),
                        child: const Text('Generate Receipt'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
