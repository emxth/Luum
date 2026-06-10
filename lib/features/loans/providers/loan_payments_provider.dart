import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/loan_provider.dart';

final loanPaymentsProvider = FutureProvider.family((ref, String loanId) async {
  return ref.read(loanRepositoryProvider).getPayments(loanId);
});
