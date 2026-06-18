import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/analytics_provider.dart';
import '../providers/category_chart_provider.dart';
import '../providers/monthly_trend_provider.dart';
import '../providers/top_category_provider.dart';
import '../providers/spending_trend_provider.dart';
import '../utils/health_helper.dart';
import '../widgets/category_bar_chart.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_trend_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);

    final topCategory = ref.watch(topCategoryProvider);

    final trend = ref.watch(spendingTrendProvider);

    final categoryChart = ref.watch(categoryChartProvider);

    final monthlyTrend = ref.watch(monthlyTrendProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            analytics.when(
              data: (data) {
                return Column(
                  children: [
                    Text(
                      'Savings Rate: '
                      '${data.savingsRate.toStringAsFixed(1)}%',
                    ),

                    Text(
                      'Health Score: '
                      '${data.financialHealthScore}',
                    ),

                    Text(healthLabel(data.financialHealthScore)),

                    Text(
                      'Average Income: '
                      'Rs. ${data.averageMonthlyIncome.toStringAsFixed(2)}',
                    ),

                    Text(
                      'Average Expense: '
                      'Rs. ${data.averageMonthlyExpense.toStringAsFixed(2)}',
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            topCategory.when(
              data: (value) => Text('Top Category: $value'),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            trend.when(
              data: (value) {
                return Column(
                  children: [
                    Text(
                      'Current Month Expense: '
                      'Rs. ${value.currentMonth}',
                    ),

                    Text(
                      'Previous Month Expense: '
                      'Rs. ${value.previousMonth}',
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            categoryChart.when(
              data: (data) {
                return CategoryPieChart(data: data);
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            categoryChart.when(
              data: (data) {
                return CategoryBarChart(data: data);
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const Divider(),

            monthlyTrend.when(
              data: (data) {
                return MonthlyTrendChart(data: data);
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
