import 'package:drift/drift.dart';

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
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}