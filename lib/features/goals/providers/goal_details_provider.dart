import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/goal_provider.dart';
import '../models/goal_details.dart';

final goalDetailsProvider = FutureProvider.family((ref, String goalId) async {
  final repository = ref.read(goalRepositoryProvider);

  final goal = await repository.getGoalById(goalId);

  if (goal == null) {
    return null;
  }

  final balance = await repository.getGoalBalance(goalId);

  final remaining = (goal.targetAmount - balance).clamp(0.0, double.infinity);

  final progress = goal.targetAmount == 0 ? 0.0 : balance / goal.targetAmount;

  return GoalDetails(
    goal: goal,
    balance: balance,
    remaining: remaining,
    progress: progress > 1 ? 1 : progress,
    isCompleted: balance >= goal.targetAmount,
  );
});
