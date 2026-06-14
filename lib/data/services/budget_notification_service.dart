import '../repositories/settings_repository.dart';
import '../repositories/transaction_repository.dart';
import 'notification_service.dart';

class BudgetNotificationService {
  final SettingsRepository settingsRepository;

  final TransactionRepository transactionRepository;

  BudgetNotificationService({
    required this.settingsRepository,
    required this.transactionRepository,
  });

  Future<void> checkThresholds() async {
    final settings = await settingsRepository.getSettings();

    if (settings == null) {
      return;
    }

    if (!settings.notificationsEnabled) {
      return;
    }

    final limit = settings.monthlyLimit ?? 0;

    if (limit <= 0) {
      return;
    }

    final spent = await transactionRepository.getCurrentMonthExpenses();

    final percentage = (spent / limit) * 100;

    await _checkAlert(percentage, settings.warningPercentage1, 1);

    await _checkAlert(percentage, settings.warningPercentage2, 2);

    await _checkAlert(percentage, settings.warningPercentage3, 3);
  }

  Future<void> _checkAlert(
    double current,
    int threshold,
    int notificationId,
  ) async {
    if (current < threshold) {
      return;
    }

    await NotificationService.show(
      id: notificationId,
      title: 'Budget Alert',
      body: 'You have reached $threshold% of your monthly budget.',
    );
  }
}
