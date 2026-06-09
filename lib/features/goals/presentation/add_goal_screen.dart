import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/goal_provider.dart';
import '../providers/goals_provider.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key});

  @override
  ConsumerState<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final nameController = TextEditingController();
  final targetController = TextEditingController();
  final noteController = TextEditingController();

  Future<void> saveGoal() async {
    final repository = ref.read(goalRepositoryProvider);

    final now = DateTime.now().toIso8601String();

    await repository.createGoal(
      GoalsCompanion.insert(
        id: const Uuid().v4(),
        name: nameController.text,
        targetAmount: double.parse(targetController.text),
        note: Value(noteController.text),
        createdAt: now,
        updatedAt: now,
      ),
    );

    ref.invalidate(goalsProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Goal')),
      body: const Center(child: Text('Goal creation form goes here')),
    );
  }
}
