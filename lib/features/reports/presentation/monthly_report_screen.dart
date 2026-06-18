import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/monthly_report_provider.dart';

class MonthlyReportScreen extends ConsumerWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(monthlyReportProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Report')),
      body: report.when(
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
    );
  }
}
