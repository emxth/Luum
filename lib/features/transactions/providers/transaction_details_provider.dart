import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';

final transactionDetailsProvider =
    FutureProvider.family(
  (ref, String transactionId) async {
    final repository =
        ref.read(transactionRepositoryProvider);

    return repository.getById(transactionId);
  },
);