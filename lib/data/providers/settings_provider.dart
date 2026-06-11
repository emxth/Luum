import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/settings_repository.dart';
import 'database_provider.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final database = ref.read(databaseProvider);

  return SettingsRepository(database);
});
