import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'tables/categories.dart';
import 'tables/payment_methods.dart';
import 'tables/transactions.dart';
import 'tables/goals.dart';
import 'tables/goal_transactions.dart';
import 'tables/loans.dart';
import 'tables/loan_payments.dart';
import 'tables/settings.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    PaymentMethods,
    Transactions,
    Goals,
    GoalTransactions,
    Loans,
    LoanPayments,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(
          settings,
          settings.lastAlertSent as GeneratedColumn<Object>,
        );

        await migrator.addColumn(
          settings,
          settings.lastAlertMonth as GeneratedColumn<Object>,
        );
      }

      if (from < 3) {
        await migrator.addColumn(
          settings,
          settings.lastBackupAt as GeneratedColumn<Object>,
        );
      }
    },
  );

  Future<int> categoryCount() async {
    final result = await select(categories).get();

    return result.length;
  }

  Future<int> paymentMethodCount() async {
    final result = await select(paymentMethods).get();

    return result.length;
  }
}
