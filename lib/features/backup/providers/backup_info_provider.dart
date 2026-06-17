import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/settings_provider.dart';

final lastBackupProvider = FutureProvider<String?>((ref) async {
  final settingsRepo = ref.read(settingsRepositoryProvider);

  final settings = await settingsRepo.getSettings();

  return settings?.lastBackupAt;
});
