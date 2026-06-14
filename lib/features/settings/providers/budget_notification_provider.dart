import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/settings_provider.dart';
import '../../../data/providers/transaction_provider.dart';
import '../../../data/services/budget_notification_service.dart';

final budgetNotificationServiceProvider = Provider<BudgetNotificationService>((
  ref,
) {
  return BudgetNotificationService(
    settingsRepository: ref.read(settingsRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
  );
});
