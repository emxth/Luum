class MonthlySummaryModel {
  final int transactionCount;

  final double averageDailyExpense;

  final String topCategory;

  const MonthlySummaryModel({
    required this.transactionCount,
    required this.averageDailyExpense,
    required this.topCategory,
  });
}
