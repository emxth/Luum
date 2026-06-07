import 'package:drift/drift.dart';

mixin TimestampColumns on Table {
  TextColumn get createdAt => text()();

  TextColumn get updatedAt => text()();
}