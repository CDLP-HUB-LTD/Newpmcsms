// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmcsms/core/theme/app_colors.dart';
// import 'package:pmcsms/presentation/features/transactions/data/model/wallet_history_request.dart';
// import 'package:pmcsms/presentation/features/transactions/presentation/notifier/get_wallet_history_notifier.dart';
// import 'package:pmcsms/presentation/general_widgets/spacing.dart';
// import 'package:pmcsms/presentation/general_widgets/transaction_widget.dart';

// class AllTransactions extends ConsumerStatefulWidget {
//   const AllTransactions({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _AllTransactionsState();
// }

// class _AllTransactionsState extends ConsumerState<AllTransactions> {
//   final data = WalletHistoryRequest(
//     process: 'pm_wallet',
//     action: 'wallet_history',
//   );

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await ref
//           .read(getWalletHistoryNotifier.notifier)
//           .getWalletHistory(data: data);
//     });
//   }

//   /// Formats a nullable DateTime into a readable string
//   String _formatDate(DateTime? date) {
//     if (date == null) return '—';
//     final d = date;
//     final day = d.day.toString().padLeft(2, '0');
//     final month = d.month.toString().padLeft(2, '0');
//     final year = d.year;
//     final hour = d.hour.toString().padLeft(2, '0');
//     final minute = d.minute.toString().padLeft(2, '0');
//     return '$day-$month-$year $hour:$minute';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final walletList = ref.watch(
//         getWalletHistoryNotifier.select((v) => v.data?.data?.history ?? []));

//     if (walletList.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: AppColors.primaryF5F7F9,
//         ),
//         child: const Center(
//           child: Text(
//             'No transactions yet.',
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//       );
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: AppColors.primaryF5F7F9,
//       ),
//       // ✅ shrinkWrap + NeverScrollableScrollPhysics so it plays nicely
//       // inside a parent scroll view (e.g. SingleChildScrollView / CustomScrollView)
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: walletList.length,
//         itemBuilder: (context, index) {
//           final transaction = walletList[index];
//           return Column(
//             children: [
//               TransactionWidget(
//                 amount: '₦${transaction.amount ?? '0.00'}',
//                 icon: 'assets/icons/income.svg',
//                 title: transaction.purpose ?? '—',
//                 date: _formatDate(transaction.date), // ✅ real date
//                 status: transaction.status ?? '—',
//               ),
//               const VerticalSpacing(20),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/transactions/components/transaction_filter_bar.dart';
import 'package:pmcsms/presentation/features/transactions/data/model/wallet_history_request.dart';
import 'package:pmcsms/presentation/features/transactions/presentation/notifier/get_wallet_history_notifier.dart';
import 'package:pmcsms/presentation/features/transactions/presentation/view/transaction_detail_view.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';
import 'package:pmcsms/presentation/general_widgets/transaction_widget.dart';

class AllTransactions extends ConsumerStatefulWidget {
  const AllTransactions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllTransactionsState();
}

class _AllTransactionsState extends ConsumerState<AllTransactions> {
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

  /// Formats a nullable DateTime into a readable string
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

  /// Heuristic: "Transfer from ..." / earnings-style purposes are credits,
  /// "Transfer to ..." / "Withdrawal" are debits.
  bool _isCredit(String purpose) {
    final p = purpose.toLowerCase();
    return !(p.startsWith('transfer to') || p.contains('withdrawal'));
  }

  List<dynamic> _applyFilters(List<dynamic> list) {
    return list.where((transaction) {
      final matchesStatus = _selectedStatus == 'All Status' ||
          (transaction.status ?? '').toString().toLowerCase() ==
              _selectedStatus.toLowerCase();
      final matchesMonth = transaction.date == null ||
          (transaction.date.month == _selectedMonth.month &&
              transaction.date.year == _selectedMonth.year);
      return matchesStatus && matchesMonth;
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
                      final isCredit = _isCredit(purpose);
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
                                    isCredit: isCredit,
                                    categoryLabel:
                                        isCredit ? 'Received' : 'Sent',
                                    transactionId:
                                        transaction.reference?.toString() ??
                                            '—',
                                    status: transaction.status ?? '—',
                                    transactionDate:
                                        _formatDate(transaction.date),
                                    category: 'Fund transfer',
                                    counterpartyLabel: 'Recipient',
                                    counterpartyName: purpose.replaceAll(
                                        RegExp(r'^Transfer (from|to)\s*'), ''),
                                    extraLabel: 'Payment Method',
                                    extraValue: 'Bank Transfer',
                                  ),
                                ),
                              );
                            },
                            child: TransactionWidget(
                              amount:
                                  '${isCredit ? '+' : '-'}₦${transaction.amount ?? '0.00'}',
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
