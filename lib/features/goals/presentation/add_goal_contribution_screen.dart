import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/goal_provider.dart';
import '../providers/goal_contributions_provider.dart';
import '../providers/goal_details_provider.dart';

class AddGoalContributionScreen extends ConsumerStatefulWidget {
  final String goalId;

  const AddGoalContributionScreen({super.key, required this.goalId});

  @override
  ConsumerState<AddGoalContributionScreen> createState() =>
      _AddGoalContributionScreenState();
}

class _AddGoalContributionScreenState
    extends ConsumerState<AddGoalContributionScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  Future<void> saveContribution() async {
    final repository = ref.read(goalRepositoryProvider);
    final now = DateTime.now().toIso8601String();
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      return;
    }

    await repository.addContribution(
      GoalTransactionsCompanion.insert(
        id: const Uuid().v4(),
        goalId: widget.goalId,
        amount: amount,
        transactionDate: now,
        note: Value(noteController.text.isEmpty ? null : noteController.text),
        createdAt: now,
      ),
    );

    ref.invalidate(goalDetailsProvider(widget.goalId));

    ref.invalidate(goalContributionsProvider(widget.goalId));

    if (mounted) {
      context.pop();
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contribution')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),

            ElevatedButton(
              onPressed: saveContribution,
              child: const Text('Save Contribution'),
            ),
          ],
        ),
      ),
    );
  }
}
