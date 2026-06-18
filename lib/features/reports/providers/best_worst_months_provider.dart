import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/best_worst_months_model.dart';
import 'yearly_report_provider.dart';

final bestWorstMonthsProvider = FutureProvider<BestWorstMonthsModel>((
  ref,
) async {
  final report = await ref.read(yearlyReportProvider.future);

  final bestIncome = report.reduce((a, b) => a.income > b.income ? a : b);

  final highestExpense = report.reduce((a, b) => a.expense > b.expense ? a : b);

  final lowestExpense = report.reduce((a, b) => a.expense < b.expense ? a : b);

  final bestSavings = report.reduce((a, b) => a.balance > b.balance ? a : b);

  return BestWorstMonthsModel(
    bestIncomeMonth: bestIncome.month,

    worstExpenseMonth: lowestExpense.month,

    highestExpenseMonth: highestExpense.month,

    bestSavingsMonth: bestSavings.month,
  );
});
