import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/loan_provider.dart';
import '../models/loan_details_model.dart';

final loanSummaryProvider = FutureProvider.family<LoanDetailsModel?, String>((
  ref,
  loanId,
) async {
  final repository = ref.read(loanRepositoryProvider);

  final loan = await repository.getLoanById(loanId);

  if (loan == null) {
    return null;
  }

  final paid = await repository.getTotalPaid(loanId);

  final remaining = loan.amount - paid;

  final progress = loan.amount == 0 ? 0.0 : paid / loan.amount;

  return LoanDetailsModel(
    loan: loan,
    paid: paid,
    remaining: remaining < 0 ? 0 : remaining,
    progress: progress > 1 ? 1 : progress,
  );
});
