import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          return Column(
            children: [
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
    );
  }
}
