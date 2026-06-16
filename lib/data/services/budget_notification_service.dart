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
    await settingsRepository.checkMonthChange();

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

    await _checkAlert(
      percentage,
      settings.warningPercentage1,
      1,
      settings.lastAlertSent,
    );

    await _checkAlert(
      percentage,
      settings.warningPercentage2,
      2,
      settings.lastAlertSent,
    );

    await _checkAlert(
      percentage,
      settings.warningPercentage3,
      3,
      settings.lastAlertSent,
    );
  }

  Future<void> _checkAlert(
    double current,
    int threshold,
    int notificationId,
    int lastAlertSent,
  ) async {
    if (current < threshold) {
      return;
    }

    if (lastAlertSent >= threshold) {
      return;
    }

    await NotificationService.show(
      id: notificationId,
      title: 'Budget Alert',
      body: 'You have reached $threshold% of your monthly budget.',
    );

    await settingsRepository.updateLastAlertSent(threshold);
  }
}
