import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/loan_repository.dart';
import 'database_provider.dart';

final loanRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);

  return LoanRepository(database);
});
