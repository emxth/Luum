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
}
