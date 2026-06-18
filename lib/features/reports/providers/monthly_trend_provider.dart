import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';
import '../models/yearly_report_model.dart' show YearlyReportModel;

final monthlyTrendProvider = FutureProvider<List<YearlyReportModel>>((
  ref,
) async {
  return ref.read(transactionRepositoryProvider).getMonthlyTrendData();
});
