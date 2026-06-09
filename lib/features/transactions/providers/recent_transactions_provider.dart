import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';

final recentTransactionsProvider = FutureProvider((ref) async {
  final repository = ref.read(transactionRepositoryProvider);

  return repository.getRecentTransactions();
});
