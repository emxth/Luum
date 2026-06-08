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
}
