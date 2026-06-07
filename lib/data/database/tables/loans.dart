import 'package:drift/drift.dart';

import 'base_table.dart';

class Loans extends Table with TimestampColumns {
  TextColumn get id => text()();

  TextColumn get personName => text()();

  RealColumn get amount => real()();

  TextColumn get loanType => text()();

  TextColumn get status => text()();

  TextColumn get note => text().nullable()();

  TextColumn get loanDate => text()();

  TextColumn get dueDate => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}