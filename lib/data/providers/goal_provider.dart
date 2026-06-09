import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/goal_repository.dart';
import 'database_provider.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final database = ref.read(databaseProvider);

  return GoalRepository(database);
});
