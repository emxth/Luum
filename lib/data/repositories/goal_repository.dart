import 'package:drift/drift.dart';

import '../database/app_database.dart';

class GoalRepository {
  final AppDatabase database;

  GoalRepository(this.database);

  Future<List<Goal>> getAllGoals() {
    return database.select(database.goals).get();
  }

  Future<Goal?> getGoalById(String id) {
    return (database.select(
      database.goals,
    )..where((g) => g.id.equals(id))).getSingleOrNull();
  }

  Future<void> createGoal(GoalsCompanion goal) async {
    await database.into(database.goals).insert(goal);
  }

  Future<void> updateGoal(Goal goal) async {
    await database.update(database.goals).replace(goal);
  }

  Future<void> deleteGoal(String id) async {
    await (database.delete(database.goals)..where((g) => g.id.equals(id))).go();
  }

  Future<void> addContribution(GoalTransactionsCompanion contribution) async {
    await database.into(database.goalTransactions).insert(contribution);
  }

  Future<List<GoalTransaction>> getContributions(String goalId) {
    return (database.select(database.goalTransactions)
          ..where((t) => t.goalId.equals(goalId))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<double> getGoalBalance(String goalId) async {
    final contributions = await getContributions(goalId);

    return contributions.fold<double>(0.0, (sum, item) => sum + item.amount);
  }
}
