class YearlyReportModel {
  final int month;

  final double income;

  final double expense;

  double get balance => income - expense;

  const YearlyReportModel({
    required this.month,
    required this.income,
    required this.expense,
  });
}
