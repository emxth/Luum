import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/goal_provider.dart';
import '../providers/active_goals_provider.dart';
import '../providers/completed_goals_provider.dart';
import '../providers/goal_dashboard_provider.dart';
import '../providers/goals_provider.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  final String? goalId;

  const AddGoalScreen({super.key, this.goalId});

  @override
  ConsumerState<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final nameController = TextEditingController();
  final targetController = TextEditingController();
  final noteController = TextEditingController();

  Future<void> saveGoal() async {
    final repository = ref.read(goalRepositoryProvider);

    final targetAmount = double.tryParse(targetController.text);

    if (nameController.text.isEmpty ||
        targetAmount == null ||
        targetAmount <= 0) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    await repository.createGoal(
      GoalsCompanion.insert(
        id: const Uuid().v4(),
        name: nameController.text,
        targetAmount: targetAmount,
        note: Value(noteController.text.isEmpty ? null : noteController.text),
        createdAt: now,
        updatedAt: now,
      ),
    );

    ref.invalidate(goalsProvider);
    ref.invalidate(activeGoalsProvider);
    ref.invalidate(completedGoalsProvider);
    ref.invalidate(goalDashboardProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    targetController.dispose();
    noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Goal Name'),
            ),

            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Amount'),
            ),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),

            ElevatedButton(onPressed: saveGoal, child: const Text('Save Goal')),
          ],
        ),
      ),
    );
  }
}
