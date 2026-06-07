import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/transaction_repository.dart';
import 'database_provider.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final database = ref.read(databaseProvider);

  return TransactionRepository(database);
});
