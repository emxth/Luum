import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/loan_provider.dart';
import '../models/loan_dashboard_model.dart';

final loanDashboardProvider = FutureProvider<LoanDashboardModel>((ref) async {
  final repository = ref.read(loanRepositoryProvider);

  final receivable = await repository.getTotalReceivable();

  final payable = await repository.getTotalPayable();

  final pending = await repository.getPendingLoanCount();

  final completed = await repository.getCompletedLoanCount();

  return LoanDashboardModel(
    totalReceivable: receivable,
    totalPayable: payable,
    pendingLoans: pending,
    completedLoans: completed,
  );
});
