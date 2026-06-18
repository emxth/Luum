import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analytics_model.dart';
import 'yearly_report_provider.dart';

final analyticsProvider = FutureProvider<AnalyticsModel>((ref) async {
  final report = await ref.read(yearlyReportProvider.future);

  double totalIncome = 0;
  double totalExpense = 0;

  for (final month in report) {
    totalIncome += month.income;
    totalExpense += month.expense;
  }

  final averageIncome = totalIncome / 12;

  final averageExpense = totalExpense / 12;

  final savingsRate = totalIncome == 0
      ? 0.0
      : ((totalIncome - totalExpense) / totalIncome) * 100;

  int healthScore;

  if (savingsRate >= 30) {
    healthScore = 100;
  } else if (savingsRate >= 20) {
    healthScore = 80;
  } else if (savingsRate >= 10) {
    healthScore = 60;
  } else if (savingsRate >= 0) {
    healthScore = 40;
  } else {
    healthScore = 20;
  }

  bool spendingIncreasing = false;

  if (report.length >= 2) {
    spendingIncreasing =
        report.last.expense > report[report.length - 2].expense;
  }

  return AnalyticsModel(
    savingsRate: savingsRate,
    averageMonthlyIncome: averageIncome,
    averageMonthlyExpense: averageExpense,
    topCategory: '',
    financialHealthScore: healthScore,
    spendingIncreasing: spendingIncreasing,
  );
});
