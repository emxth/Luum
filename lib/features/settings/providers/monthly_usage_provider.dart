import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';

class MonthlyUsage {
  final double income;
  final double expense;

  const MonthlyUsage({required this.income, required this.expense});
}

final monthlyUsageProvider = FutureProvider<MonthlyUsage>((ref) async {
  final repository = ref.read(transactionRepositoryProvider);

  final income = await repository.getCurrentMonthIncome();

  final expense = await repository.getCurrentMonthExpenses();

  return MonthlyUsage(income: income, expense: expense);
});
