import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/settings_provider.dart';
import '../../../data/providers/transaction_provider.dart';

import '../models/budget_summary_model.dart';

final budgetSummaryProvider = FutureProvider<BudgetSummaryModel>((ref) async {
  final transactionRepo = ref.read(transactionRepositoryProvider);

  final settingsRepo = ref.read(settingsRepositoryProvider);

  final settings = await settingsRepo.getSettings();

  final spent = await transactionRepo.getCurrentMonthExpenses();

  final limit = settings?.monthlyLimit ?? 0;

  final remaining = limit - spent;

  final progress = limit == 0 ? 0.0 : spent / limit;

  return BudgetSummaryModel(
    monthlyLimit: limit,
    spent: spent,
    remaining: remaining,
    progress: progress > 1 ? 1 : progress,
  );
});
