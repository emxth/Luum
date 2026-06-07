import 'package:drift/drift.dart';

import 'goals.dart';

class GoalTransactions extends Table {
  TextColumn get id => text()();

  TextColumn get goalId =>
      text().references(Goals, #id)();

  RealColumn get amount => real()();

  TextColumn get note => text().nullable()();

  TextColumn get transactionDate => text()();

  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}