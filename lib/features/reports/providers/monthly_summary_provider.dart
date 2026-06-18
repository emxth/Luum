import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';
import '../models/monthly_summary_model.dart';

final monthlySummaryProvider = FutureProvider<MonthlySummaryModel>((ref) async {
  final repository = ref.read(transactionRepositoryProvider);

  final breakdown = await repository.getCurrentMonthExpenseByCategory();

  final transactionCount = await repository.getCurrentMonthTransactionCount();

  final expense = await repository.getCurrentMonthExpenses();

  final now = DateTime.now();

  final averageDailyExpense = expense / now.day;

  return MonthlySummaryModel(
    transactionCount: transactionCount,

    averageDailyExpense: averageDailyExpense,
    
    topCategory: breakdown.isEmpty ? '-' : breakdown.first.categoryName,
  );
});
