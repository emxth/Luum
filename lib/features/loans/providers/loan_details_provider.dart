import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/loan_provider.dart';
import '../../../data/database/app_database.dart';

final loanDetailsProvider = FutureProvider.family<Loan?, String>((
  ref,
  loanId,
) async {
  final repository = ref.read(loanRepositoryProvider);

  return repository.getLoanById(loanId);
});
