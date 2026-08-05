import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/transactions/components/transaction_filter_bar.dart';
import 'package:pmcsms/presentation/features/transactions/data/model/wallet_history_request.dart';
import 'package:pmcsms/presentation/features/transactions/presentation/notifier/get_wallet_history_notifier.dart';
import 'package:pmcsms/presentation/features/transactions/presentation/view/transaction_detail_view.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';
import 'package:pmcsms/presentation/general_widgets/transaction_widget.dart';

class AddFundsTransactions extends ConsumerStatefulWidget {
  const AddFundsTransactions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddFundsTransactionsState();
}

class _AddFundsTransactionsState extends ConsumerState<AddFundsTransactions> {
  final data = WalletHistoryRequest(
    process: 'pm_wallet',
    action: 'wallet_history',
  );

  DateTime _selectedMonth = DateTime.now();
  String _selectedStatus = TransactionFilterBar.statusOptions.first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(getWalletHistoryNotifier.notifier)
          .getWalletHistory(data: data);
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    final d = date;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year;
    final hour = d.hour.toString().padLeft(2, '0');
    final minute = d.minute.toString().padLeft(2, '0');
    return '$day-$month-$year $hour:$minute';
  }

  /// Only "add funds" style entries — deposits/top-ups into the wallet.
  bool _isAddFunds(String purpose) {
    final p = purpose.toLowerCase();
    return p.contains('add fund') ||
        p.contains('deposit') ||
        p.contains('fund wallet');
  }

  List<dynamic> _applyFilters(List<dynamic> list) {
    return list.where((transaction) {
      final purpose = (transaction.purpose ?? '').toString();
      final matchesType = _isAddFunds(purpose);
      final matchesStatus = _selectedStatus == 'All Status' ||
          (transaction.status ?? '').toString().toLowerCase() ==
              _selectedStatus.toLowerCase();
      final matchesMonth = transaction.date == null ||
          (transaction.date.month == _selectedMonth.month &&
              transaction.date.year == _selectedMonth.year);
      return matchesType && matchesStatus && matchesMonth;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final walletList = ref.watch(
        getWalletHistoryNotifier.select((v) => v.data?.data?.history ?? []));
    final filteredList = _applyFilters(walletList);

    return Column(
      children: [
        TransactionFilterBar(
          selectedMonth: _selectedMonth,
          selectedStatus: _selectedStatus,
          onMonthChanged: (value) => setState(() => _selectedMonth = value),
          onStatusChanged: (value) => setState(() => _selectedStatus = value),
        ),
        Expanded(
          child: filteredList.isEmpty
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryF5F7F9,
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_rounded, size: 40, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No recent transactions',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryF5F7F9,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredList[index];
                      final purpose = transaction.purpose ?? '—';
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TransactionDetailView(
                                    title: purpose,
                                    amount: '₦${transaction.amount ?? '0.00'}',
                                    isCredit: true,
                                    categoryLabel: 'Added',
                                    transactionId:
                                        transaction.reference?.toString() ??
                                            '—',
                                    status: transaction.status ?? '—',
                                    transactionDate:
                                        _formatDate(transaction.date),
                                    category: 'Add funds',
                                    extraLabel: 'Payment Method',
                                    extraValue: 'Bank Transfer',
                                  ),
                                ),
                              );
                            },
                            child: TransactionWidget(
                              amount: '+₦${transaction.amount ?? '0.00'}',
                              icon: 'assets/icons/income.svg',
                              title: purpose,
                              date: _formatDate(transaction.date),
                              status: transaction.status ?? '—',
                            ),
                          ),
                          const VerticalSpacing(20),
                        ],
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
