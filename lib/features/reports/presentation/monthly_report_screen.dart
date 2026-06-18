import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/monthly_report_provider.dart';
import '../providers/category_breakdown_provider.dart';
import '../providers/monthly_summary_provider.dart';

class MonthlyReportScreen extends ConsumerWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(monthlyReportProvider);

    final categories = ref.watch(categoryBreakdownProvider);

    final summary = ref.watch(monthlySummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Report')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            report.when(
              data: (data) {
                return Column(
                  children: [
                    Text('Income: Rs. ${data.income}'),

                    Text('Expense: Rs. ${data.expense}'),

                    Text('Balance: Rs. ${data.balance}'),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            const Text('Category Breakdown'),

            categories.when(
              data: (items) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      title: Text(item.categoryName),
                      trailing: Text('Rs. ${item.amount}'),
                    );
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            const Text('Monthly Summary'),

            summary.when(
              data: (data) {
                return Column(
                  children: [
                    Text(
                      'Transactions: '
                      '${data.transactionCount}',
                    ),

                    Text(
                      'Top Category: '
                      '${data.topCategory}',
                    ),

                    Text(
                      'Average Daily Expense: '
                      'Rs. ${data.averageDailyExpense.toStringAsFixed(2)}',
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
