import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';

class SpendingTrend {
  final double currentMonth;
  final double previousMonth;

  const SpendingTrend({
    required this.currentMonth,
    required this.previousMonth,
  });
}

final spendingTrendProvider = FutureProvider<SpendingTrend>((ref) async {
  final repo = ref.read(transactionRepositoryProvider);

  final now = DateTime.now();

  final current = await repo.getExpenseForMonth(now.year, now.month);

  final previousDate = DateTime(now.year, now.month - 1);

  final previous = await repo.getExpenseForMonth(
    previousDate.year,
    previousDate.month,
  );

  return SpendingTrend(currentMonth: current, previousMonth: previous);
});
