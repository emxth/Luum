import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';
import '../models/dashboard_summary.dart';

final dashboardProvider = FutureProvider((ref) async {
  final repository = ref.read(transactionRepositoryProvider);

  final income = await repository.getTotalIncome();

  final expense = await repository.getTotalExpense();

  final balance = income - expense;

  final monthIncome = await repository.getCurrentMonthIncome();

  final monthExpense = await repository.getCurrentMonthExpenses();

  final monthBalance = await repository.getCurrentMonthBalance();

  return DashboardSummary(
    totalIncome: income,
    totalExpense: expense,
    balance: balance,
    monthIncome: monthIncome,
    monthExpense: monthExpense,
    monthBalance: monthBalance,
  );
});
