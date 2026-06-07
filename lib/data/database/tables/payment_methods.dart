import 'package:drift/drift.dart';

import 'base_table.dart';

class PaymentMethods extends Table with TimestampColumns {
  TextColumn get id => text()();

  TextColumn get name => text()();

  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}