import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/best_worst_months_provider.dart';
import '../providers/year_summary_provider.dart';
import '../providers/yearly_report_provider.dart';
import '../utils/month_helper.dart';

class YearlyReportScreen extends ConsumerWidget {
  const YearlyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(yearlyReportProvider);

    final summary = ref.watch(yearSummaryProvider);

    final bestWorst = ref.watch(bestWorstMonthsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Yearly Report')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            summary.when(
              data: (data) {
                return Column(
                  children: [
                    Text('Income: Rs. ${data.income}'),

                    Text('Expense: Rs. ${data.expense}'),

                    Text('Balance: Rs. ${data.balance}'),

                    Text(
                      'Savings Rate: '
                      '${data.savingsRate.toStringAsFixed(1)}%',
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            report.when(
              data: (items) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final month = items[index];

                    return ListTile(
                      title: Text(monthName(month.month)),
                      subtitle: Text(
                        'Income: ${month.income} | Expense: ${month.expense}',
                      ),
                    );
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            bestWorst.when(
              data: (data) {
                return Column(
                  children: [
                    Text(
                      'Best Income Month: '
                      '${monthName(data.bestIncomeMonth)}',
                    ),

                    Text(
                      'Highest Expense Month: '
                      '${monthName(data.highestExpenseMonth)}',
                    ),

                    Text(
                      'Lowest Expense Month: '
                      '${monthName(data.worstExpenseMonth)}',
                    ),

                    Text(
                      'Best Savings Month: '
                      '${monthName(data.bestSavingsMonth)}',
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
