import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'monthly_report_provider.dart';

final savingsRateProvider = FutureProvider<double>((ref) async {
  final report = await ref.read(monthlyReportProvider.future);

  if (report.income <= 0) {
    return 0;
  }

  return (report.balance / report.income) * 100;
});
