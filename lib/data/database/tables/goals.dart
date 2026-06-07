import 'package:drift/drift.dart';

import 'base_table.dart';

class Goals extends Table with TimestampColumns {
  TextColumn get id => text()();

  TextColumn get name => text()();

  RealColumn get targetAmount => real()();

  TextColumn get note => text().nullable()();

  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}