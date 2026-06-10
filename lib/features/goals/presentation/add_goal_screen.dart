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
  bool _isLoading = true;

  Future<void> saveGoal() async {
    final repository = ref.read(goalRepositoryProvider);

    final targetAmount = double.tryParse(targetController.text);

    if (nameController.text.isEmpty ||
        targetAmount == null ||
        targetAmount <= 0) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    if (widget.goalId != null) {
      final existingGoal = await repository.getGoalById(widget.goalId!);

      if (existingGoal != null) {
        await repository.updateGoal(
          existingGoal.copyWith(
            name: nameController.text,
            targetAmount: targetAmount,
            note: Value(
              noteController.text.isEmpty ? null : noteController.text,
            ),
            updatedAt: now,
          ),
        );
      }
    } else {
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
    }

    ref.invalidate(goalsProvider);
    ref.invalidate(activeGoalsProvider);
    ref.invalidate(completedGoalsProvider);
    ref.invalidate(goalDashboardProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.goalId != null) {
      _loadGoal();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadGoal() async {
    final repository = ref.read(goalRepositoryProvider);

    final goal = await repository.getGoalById(widget.goalId!);

    if (goal != null && mounted) {
      setState(() {
        nameController.text = goal.name;

        targetController.text = goal.targetAmount.toString();

        noteController.text = goal.note ?? '';

        _isLoading = false;
      });
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
    final isEditing = widget.goalId != null;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Goal' : 'Add Goal')),
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

            ElevatedButton(
              onPressed: saveGoal,
              child: Text(isEditing ? 'Update Goal' : 'Save Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
