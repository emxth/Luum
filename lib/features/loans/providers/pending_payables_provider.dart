import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/loan_provider.dart';

final pendingPayablesProvider = FutureProvider<double>((ref) {
  return ref.read(loanRepositoryProvider).getTotalPayable();
});
