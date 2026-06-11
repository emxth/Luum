import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/loan_provider.dart';

final recentLoanActivityProvider = FutureProvider((ref) {
  return ref.read(loanRepositoryProvider).getRecentPayments();
});
