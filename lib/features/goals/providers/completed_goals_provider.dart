import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/goal_provider.dart';

final completedGoalsProvider = FutureProvider((ref) async {
  final repository = ref.read(goalRepositoryProvider);

  final goals = await repository.getAllGoals();

  return goals.where((g) => g.isCompleted).toList();
});
