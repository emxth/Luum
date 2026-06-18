import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';
import '../models/category_breakdown_model.dart';

final categoryBreakdownProvider = FutureProvider<List<CategoryBreakdownModel>>((
  ref,
) async {
  return ref
      .read(transactionRepositoryProvider)
      .getCurrentMonthExpenseByCategory();
});
