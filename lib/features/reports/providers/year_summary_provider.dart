import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/year_summary_model.dart';
import 'yearly_report_provider.dart';

final yearSummaryProvider = FutureProvider<YearSummaryModel>((ref) async {
  final report = await ref.read(yearlyReportProvider.future);

  double income = 0;
  double expense = 0;

  for (final month in report) {
    income += month.income;
    expense += month.expense;
  }

  final balance = income - expense;

  final savingsRate = income == 0 ? 0.0 : (balance / income) * 100;

  return YearSummaryModel(
    income: income,
    expense: expense,
    balance: balance,
    savingsRate: savingsRate,
  );
});
