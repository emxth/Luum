import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/payment_method_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../data/repositories/goal_repository.dart';
import '../../../data/repositories/loan_repository.dart';
import '../../../data/repositories/settings_repository.dart';

import '../models/backup_model.dart';

class BackupService {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;
  final PaymentMethodRepository paymentMethodRepository;
  final GoalRepository goalRepository;
  final LoanRepository loanRepository;
  final SettingsRepository settingsRepository;

  BackupService({
    required this.transactionRepository,
    required this.categoryRepository,
    required this.paymentMethodRepository,
    required this.goalRepository,
    required this.loanRepository,
    required this.settingsRepository,
  });

  Future<File> createBackup() async {
    final transactions = await transactionRepository.getAllTransactions();

    final categories = await categoryRepository.getAllCategories();

    final paymentMethods = await paymentMethodRepository.getAllPaymentMethods();

    final goals = await goalRepository.getAllGoals();

    final goalTransactions = await goalRepository.getAllGoalTransactions();

    final loans = await loanRepository.getAllLoans();

    final loanPayments = await loanRepository.getAllLoanPayments();

    final settings = await settingsRepository.getSettings();

    final backup = BackupModel(
      version: 1,
      app: 'Luum',
      createdAt: DateTime.now().toUtc().toIso8601String(),
      data: {
        'transactions': transactions.map((e) => e.toJson()).toList(),

        'categories': categories.map((e) => e.toJson()).toList(),

        'payment_methods': paymentMethods.map((e) => e.toJson()).toList(),

        'goals': goals.map((e) => e.toJson()).toList(),

        'goal_transactions': goalTransactions.map((e) => e.toJson()).toList(),

        'loans': loans.map((e) => e.toJson()).toList(),

        'loan_payments': loanPayments.map((e) => e.toJson()).toList(),

        'settings': settings?.toJson(),
      },
    );

    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(backup.toJson());

    final root = await getApplicationDocumentsDirectory();

    final backupDir = Directory('${root.path}/Luum Backups');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final now = DateTime.now();

    final fileName =
        'luum_backup_'
        '${now.year}_'
        '${now.month.toString().padLeft(2, '0')}_'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}_'
        '${now.minute.toString().padLeft(2, '0')}_'
        '${now.second.toString().padLeft(2, '0')}'
        '.json';

    final file = File('${backupDir.path}/$fileName');

    await file.writeAsString(jsonString);

    await settingsRepository.updateLastBackupDate(
      DateTime.now().toIso8601String(),
    );

    return file;
  }

  Future<void> shareBackup(File file) async {
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<void> runAutoBackup() async {
    final settings = await settingsRepository.getSettings();

    if (settings == null) {
      return;
    }

    if (!settings.backupEnabled) {
      return;
    }

    final lastBackupAt = settings.lastBackupAt;

    if (lastBackupAt == null) {
      await createBackup();
      return;
    }

    final lastBackup = DateTime.parse(lastBackupAt);

    final now = DateTime.now();

    final frequency = settings.backupFrequency;

    bool shouldBackup = false;

    switch (frequency) {
      case 'daily':
        shouldBackup = now.difference(lastBackup).inDays >= 1;
        break;

      case 'weekly':
        shouldBackup = now.difference(lastBackup).inDays >= 7;
        break;

      case 'monthly':
        shouldBackup = now.difference(lastBackup).inDays >= 30;
        break;

      default:
        shouldBackup = false;
    }

    if (shouldBackup) {
      await createBackup();
    }
  }
}
