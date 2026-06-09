import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/goal_provider.dart';
import '../models/goal_dashboard.dart';

final goalDashboardProvider = FutureProvider((ref) async {
  final repository = ref.read(goalRepositoryProvider);

  final goals = await repository.getAllGoals();

  double totalSaved = 0;

  for (final goal in goals) {
    totalSaved += await repository.getGoalBalance(goal.id);
  }

  return GoalDashboard(
    totalGoals: goals.length,
    activeGoals: goals.where((g) => !g.isCompleted).length,
    completedGoals: goals.where((g) => g.isCompleted).length,
    totalSaved: totalSaved,
  );
});
