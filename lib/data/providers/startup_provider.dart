import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/seed_service.dart';
import 'settings_provider.dart';

final startupProvider = FutureProvider<void>((ref) async {
  final database = ref.read(databaseProvider);

  final seedService = SeedService(database);

  final settingsRepo = ref.read(settingsRepositoryProvider);

  final settings = await settingsRepo.getSettings();

  if (settings == null) {
    await database
        .into(database.settings)
        .insert(
          SettingsCompanion.insert(
            id: const Value(1),
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          ),
        );
  }

  await seedService.seed();

  await settingsRepo.checkMonthChange();
});
