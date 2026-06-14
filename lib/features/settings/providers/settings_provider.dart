import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/settings_provider.dart';

final settingsProvider = FutureProvider((ref) {
  return ref.read(settingsRepositoryProvider).getSettings();
});
