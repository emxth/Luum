import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final double limit;
  final double spent;
  final double remaining;
  final double progress;

  const BudgetCard({
    super.key,
    required this.limit,
    required this.spent,
    required this.remaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Monthly Budget'),

            const SizedBox(height: 8),

            LinearProgressIndicator(value: progress),

            const SizedBox(height: 8),

            Text('${(progress * 100).toStringAsFixed(1)}%'),

            Text('Spent: Rs. ${spent.toStringAsFixed(2)}'),

            Text('Remaining: Rs. ${remaining.toStringAsFixed(2)}'),

            Text('Limit: Rs. ${limit.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
