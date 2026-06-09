import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/goal_provider.dart';

final goalsProvider = FutureProvider((ref) async {
  final repository = ref.read(goalRepositoryProvider);

  return repository.getAllGoals();
});
