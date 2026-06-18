import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/transaction_provider.dart';
import '../models/yearly_report_model.dart';

final yearlyReportProvider = FutureProvider<List<YearlyReportModel>>((
  ref,
) async {
  final repository = ref.read(transactionRepositoryProvider);

  return repository.getYearlyReport(DateTime.now().year);
});
