import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/loan_provider.dart';

final loansProvider = FutureProvider((ref) async {
  return ref.read(loanRepositoryProvider).getAllLoans();
});
