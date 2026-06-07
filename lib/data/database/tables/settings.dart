import 'package:drift/drift.dart';

class Settings extends Table {
  IntColumn get id => integer()();

  RealColumn get monthlyLimit => real().nullable()();

  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get backupEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get darkModeEnabled =>
      boolean().withDefault(const Constant(false))();

  TextColumn get backupFrequency =>
      text().withDefault(const Constant('weekly'))();

  IntColumn get warningPercentage1 =>
      integer().withDefault(const Constant(80))();

  IntColumn get warningPercentage2 =>
      integer().withDefault(const Constant(90))();

  IntColumn get warningPercentage3 =>
      integer().withDefault(const Constant(100))();

  TextColumn get createdAt => text()();

  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}