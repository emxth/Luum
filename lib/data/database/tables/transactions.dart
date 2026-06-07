import 'package:drift/drift.dart';

import 'base_table.dart';
import 'categories.dart';
import 'payment_methods.dart';

class Transactions extends Table with TimestampColumns {
  TextColumn get id => text()();

  TextColumn get date => text()();

  RealColumn get amount => real()();

  TextColumn get type => text()();

  TextColumn get categoryId =>
      text().references(Categories, #id)();

  TextColumn get paymentMethodId =>
      text().nullable().references(PaymentMethods, #id)();

  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}