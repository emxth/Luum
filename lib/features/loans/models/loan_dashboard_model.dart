class LoanDashboardModel {
  final double totalReceivable;
  final double totalPayable;

  final int pendingLoans;
  final int completedLoans;

  const LoanDashboardModel({
    required this.totalReceivable,
    required this.totalPayable,
    required this.pendingLoans,
    required this.completedLoans,
  });
}
