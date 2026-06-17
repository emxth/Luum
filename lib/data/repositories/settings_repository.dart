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

  Future<void> resetMonthlyAlerts() async {
    final currentMonth = '${DateTime.now().year}-${DateTime.now().month}';

    await (database.update(
      database.settings,
    )..where((tbl) => tbl.id.equals(1))).write(
      SettingsCompanion(
        lastAlertSent: const Value(0),
        lastAlertMonth: Value(currentMonth),
      ),
    );
  }

  Future<void> checkMonthChange() async {
    final settings = await getSettings();

    if (settings == null) {
      return;
    }

    final currentMonth = '${DateTime.now().year}-${DateTime.now().month}';

    if (settings.lastAlertMonth != currentMonth) {
      await resetMonthlyAlerts();
    }
  }

  Future<void> updateLastAlertSent(int value) async {
    await (database.update(database.settings)..where((tbl) => tbl.id.equals(1)))
        .write(SettingsCompanion(lastAlertSent: Value(value)));
  }

  Future<void> updateLastBackupDate(String value) async {
    await (database.update(database.settings)..where((tbl) => tbl.id.equals(1)))
        .write(SettingsCompanion(lastBackupAt: Value(value)));
  }

  Future<void> updateBackupFrequency(String value) async {
    await (database.update(database.settings)..where((tbl) => tbl.id.equals(1)))
        .write(SettingsCompanion(backupFrequency: Value(value)));
  }
}
