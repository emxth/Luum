class AnalyticsModel {
  final double savingsRate;

  final double averageMonthlyIncome;

  final double averageMonthlyExpense;

  final String topCategory;

  final int financialHealthScore;

  final bool spendingIncreasing;

  const AnalyticsModel({
    required this.savingsRate,
    required this.averageMonthlyIncome,
    required this.averageMonthlyExpense,
    required this.topCategory,
    required this.financialHealthScore,
    required this.spendingIncreasing,
  });
}
