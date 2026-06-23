import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_bottom_navigation.dart';
import '../../../data/providers/goal_provider.dart';
import '../providers/active_goals_provider.dart';
import '../providers/completed_goals_provider.dart';
import '../providers/goal_dashboard_provider.dart';
import '../providers/goals_provider.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: goals.when(
        data: (items) {
          final dashboard = ref.watch(goalDashboardProvider);

          return Column(
            children: [
              dashboard.when(
                data: (summary) {
                  return Column(
                    children: [
                      Text('Total Goals: ${summary.totalGoals}'),

                      Text('Active Goals: ${summary.activeGoals}'),

                      Text('Completed Goals: ${summary.completedGoals}'),

                      Text('Total Saved: Rs. ${summary.totalSaved}'),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              ElevatedButton(
                onPressed: () {
                  context.push('/goals/add');
                },
                child: const Text('New Goal'),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final goal = items[index];

                    return ListTile(
                      title: Text(goal.name),

                      subtitle: Text('Target: Rs. ${goal.targetAmount}'),

                      leading: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push('/goals/edit/${goal.id}');
                        },
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await ref
                              .read(goalRepositoryProvider)
                              .deleteGoal(goal.id);

                          ref.invalidate(goalsProvider);

                          ref.invalidate(activeGoalsProvider);

                          ref.invalidate(completedGoalsProvider);

                          ref.invalidate(goalDashboardProvider);
                        },
                      ),

                      onTap: () {
                        context.push('/goals/details/${goal.id}');
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text(e.toString()),
      ),

      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }
}
