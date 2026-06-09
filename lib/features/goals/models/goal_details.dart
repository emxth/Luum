import '../../../data/database/app_database.dart';

class GoalDetails {
  final Goal goal;

  final double balance;

  final double remaining;

  final double progress;

  final bool isCompleted;

  GoalDetails({
    required this.goal,
    required this.balance,
    required this.remaining,
    required this.progress,
    required this.isCompleted,
  });
}
