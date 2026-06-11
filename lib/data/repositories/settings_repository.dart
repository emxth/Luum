import '../database/app_database.dart';

class SettingsRepository {
  final AppDatabase database;

  SettingsRepository(this.database);

  Future<Setting?> getSettings() {
    return (database.select(
      database.settings,
    )..where((tbl) => tbl.id.equals(1))).getSingleOrNull();
  }
}
