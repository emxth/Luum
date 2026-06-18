import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';
import '../models/monthly_report_model.dart';

final monthlyReportProvider = FutureProvider<MonthlyReportModel>((ref) async {
  final repository = ref.read(transactionRepositoryProvider);

  final now = DateTime.now();

  final income = await repository.getIncomeForMonth(now.year, now.month);

  final expense = await repository.getExpenseForMonth(now.year, now.month);

  return MonthlyReportModel(
    income: income,
    expense: expense,
    balance: income - expense,
  );
});
