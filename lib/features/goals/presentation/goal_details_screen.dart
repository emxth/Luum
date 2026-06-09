import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/goal_contributions_provider.dart';
import '../providers/goal_details_provider.dart';

class GoalDetailsScreen extends ConsumerWidget {
  final String goalId;

  const GoalDetailsScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(goalDetailsProvider(goalId));

    final contributions = ref.watch(goalContributionsProvider(goalId));

    return Scaffold(
      appBar: AppBar(title: const Text('Goal')),
      body: details.when(
        data: (goal) {
          if (goal == null) {
            return const Center(child: Text('Not found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(goal.goal.name),

              Text('Target: Rs. ${goal.goal.targetAmount}'),

              Text('Saved: Rs. ${goal.balance}'),

              Text('Remaining: Rs. ${goal.remaining}'),

              LinearProgressIndicator(value: goal.progress),

              Text('${(goal.progress * 100).toStringAsFixed(1)}%'),

              Text(goal.isCompleted ? 'Completed' : 'Active'),

              ElevatedButton(
                onPressed: () {
                  context.push('/goals/$goalId/contribute');
                },
                child: const Text('Add Contribution'),
              ),

              const Divider(),

              const Text('Contribution History'),

              Expanded(
                child: contributions.when(
                  data: (items) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return ListTile(
                          title: Text('Rs. ${item.amount}'),
                          subtitle: Text(item.transactionDate),
                        );
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  context.push('/goals/$goalId/contribute');
                },
                child: const Text('Add Contribution'),
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text(e.toString()),
      ),
    );
  }
}
