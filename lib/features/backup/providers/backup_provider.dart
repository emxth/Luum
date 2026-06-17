import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/category_provider.dart';
import '../../../data/providers/payment_method_provider.dart';
import '../../../data/providers/transaction_provider.dart';
import '../../../data/providers/goal_provider.dart';
import '../../../data/providers/loan_provider.dart';
import '../../../data/providers/settings_provider.dart';

import '../services/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    transactionRepository: ref.read(transactionRepositoryProvider),

    categoryRepository: ref.read(categoryRepositoryProvider),

    paymentMethodRepository: ref.read(paymentMethodRepositoryProvider),

    goalRepository: ref.read(goalRepositoryProvider),

    loanRepository: ref.read(loanRepositoryProvider),

    settingsRepository: ref.read(settingsRepositoryProvider),
  );
});
