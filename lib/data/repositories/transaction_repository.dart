import 'package:drift/drift.dart';

import '../database/app_database.dart';

class TransactionRepository {
  final AppDatabase database;

  TransactionRepository(this.database);

  Future<List<Transaction>> getAllTransactions() {
    return (database.select(
      database.transactions,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
  }

  Future<void> createTransaction(TransactionsCompanion transaction) async {
    await database.into(database.transactions).insert(transaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await database.update(database.transactions).replace(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await (database.delete(
      database.transactions,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Transaction?> getById(String id) {
    return (database.select(
      database.transactions,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<double> getTotalIncome() async {
    final rows = await (database.select(
      database.transactions,
    )..where((t) => t.type.equals('income'))).get();

    return rows.fold<double>(0.0, (sum, item) => sum + item.amount);
  }

  Future<double> getTotalExpense() async {
    final rows = await (database.select(
      database.transactions,
    )..where((t) => t.type.equals('expense'))).get();

    return rows.fold<double>(0.0, (sum, item) => sum + item.amount);
  }

  Future<double> getCurrentBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();

    return income - expense;
  }

  Future<double> getCurrentMonthIncome() async {
    final now = DateTime.now();

    final rows = await database.select(database.transactions).get();

    return rows
        .where((t) {
          final date = DateTime.parse(t.date);

          return t.type == 'income' &&
              date.year == now.year &&
              date.month == now.month;
        })
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  Future<double> getCurrentMonthExpense() async {
    final now = DateTime.now();

    final rows = await database.select(database.transactions).get();

    return rows
        .where((t) {
          final date = DateTime.parse(t.date);

          return t.type == 'expense' &&
              date.year == now.year &&
              date.month == now.month;
        })
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  Future<double> getCurrentMonthBalance() async {
    final monthIncome = await getCurrentMonthIncome();
    final monthExpense = await getCurrentMonthExpense();

    return monthIncome - monthExpense;
  }

  Future<List<Transaction>> getRecentTransactions() {
    return (database.select(database.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(5))
        .get();
  }
}
