import 'package:drift/drift.dart';

import '../../features/reports/models/category_breakdown_model.dart';
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

    final start = DateTime(now.year, now.month, 1);

    final end = DateTime(now.year, now.month + 1, 1);

    final transactions =
        await (database.select(database.transactions)..where(
              (t) =>
                  t.type.equals('income') &
                  t.date.isBiggerOrEqualValue(start.toIso8601String()) &
                  t.date.isSmallerThanValue(end.toIso8601String()),
            ))
            .get();

    return transactions.fold<double>(0.0, (sum, item) => sum + item.amount);
  }

  Future<double> getCurrentMonthExpenses() async {
    final now = DateTime.now();

    final start = DateTime(now.year, now.month, 1);

    final end = DateTime(now.year, now.month + 1, 1);

    final transactions =
        await (database.select(database.transactions)..where(
              (t) =>
                  t.type.equals('expense') &
                  t.date.isBiggerOrEqualValue(start.toIso8601String()) &
                  t.date.isSmallerThanValue(end.toIso8601String()),
            ))
            .get();

    return transactions.fold<double>(0.0, (sum, item) => sum + item.amount);
  }

  Future<double> getCurrentMonthBalance() async {
    final monthIncome = await getCurrentMonthIncome();
    final monthExpense = await getCurrentMonthExpenses();

    return monthIncome - monthExpense;
  }

  Future<List<Transaction>> getRecentTransactions() {
    return (database.select(database.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(5))
        .get();
  }

  Future<double> getIncomeForMonth(int year, int month) async {
    final rows = await database
        .customSelect(
          '''
          SELECT SUM(amount) total
          FROM transactions
          WHERE type = 'income'
          AND strftime('%Y', date)=?
          AND strftime('%m', date)=?
          ''',
          variables: [
            Variable(year.toString()),
            Variable(month.toString().padLeft(2, '0')),
          ],
        )
        .getSingle();

    return (rows.data['total'] as num?)?.toDouble() ?? 0;
  }

  Future<double> getExpenseForMonth(int year, int month) async {
    final rows = await database
        .customSelect(
          '''
          SELECT SUM(amount) total
          FROM transactions
          WHERE type = 'expense'
          AND strftime('%Y', date)=?
          AND strftime('%m', date)=?
          ''',
          variables: [
            Variable(year.toString()),
            Variable(month.toString().padLeft(2, '0')),
          ],
        )
        .getSingle();

    return (rows.data['total'] as num?)?.toDouble() ?? 0;
  }

  Future<int> getCurrentMonthTransactionCount() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);

    final rows =
        await (database.select(database.transactions)..where(
              (t) =>
                  t.date.isBiggerOrEqualValue(start.toIso8601String()) &
                  t.date.isSmallerThanValue(end.toIso8601String()),
            ))
            .get();

    return rows.length;
  }

  Future<List<CategoryBreakdownModel>>
  getCurrentMonthExpenseByCategory() async {
    final now = DateTime.now();

    final result = await database
        .customSelect(
          '''
          SELECT
            c.name as category_name,
            SUM(t.amount) as total_amount
          FROM transactions t
          INNER JOIN categories c
            ON c.id = t.category_id
          WHERE t.type = 'expense'
            AND strftime('%Y', t.date) = ?
            AND strftime('%m', t.date) = ?
          GROUP BY c.name
          ORDER BY total_amount DESC
          ''',
          variables: [
            Variable(now.year.toString()),
            Variable(now.month.toString().padLeft(2, '0')),
          ],
        )
        .get();

    return result.map((row) {
      return CategoryBreakdownModel(
        categoryName: row.read<String>('category_name'),
        amount: (row.data['total_amount'] as num).toDouble(),
      );
    }).toList();
  }
}
