import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/database_provider.dart';
import '../services/seed_service.dart';

final startupProvider = FutureProvider<void>((ref) async {
  final database = ref.read(databaseProvider);

  final seedService = SeedService(database);

  await seedService.seed();
});
