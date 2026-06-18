import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';
import '../models/chart_data.dart';

final categoryChartProvider = FutureProvider<List<ChartData>>((ref) async {
  return ref.read(transactionRepositoryProvider).getExpenseCategoryChartData();
});
