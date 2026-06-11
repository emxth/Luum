class BudgetSummaryModel {
  final double monthlyLimit;

  final double spent;

  final double remaining;

  final double progress;

  const BudgetSummaryModel({
    required this.monthlyLimit,
    required this.spent,
    required this.remaining,
    required this.progress,
  });
}
