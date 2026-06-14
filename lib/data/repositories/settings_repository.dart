import 'package:drift/drift.dart';

import '../database/app_database.dart';

class SettingsRepository {
  final AppDatabase database;

  SettingsRepository(this.database);

  Future<Setting?> getSettings() {
    return (database.select(
      database.settings,
    )..where((tbl) => tbl.id.equals(1))).getSingleOrNull();
  }

  Future<void> createDefaultSettings() async {
    final existing = await getSettings();

    if (existing != null) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    await database
        .into(database.settings)
        .insert(
          SettingsCompanion.insert(
            id: const Value(1),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> updateSettings(SettingsCompanion settings) async {
    await (database.update(
      database.settings,
    )..where((tbl) => tbl.id.equals(1))).write(settings);
  }
}
