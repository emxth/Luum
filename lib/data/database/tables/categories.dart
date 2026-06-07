import 'package:drift/drift.dart';

import 'base_table.dart';

class Categories extends Table with TimestampColumns {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get type => text()();

  TextColumn get icon => text().nullable()();

  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}