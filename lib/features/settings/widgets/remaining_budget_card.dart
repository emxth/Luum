import 'package:flutter/material.dart';

class RemainingBudgetCard extends StatelessWidget {
  final double remaining;

  const RemainingBudgetCard({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Remaining Budget'),
        subtitle: Text('Rs. ${remaining.toStringAsFixed(2)}'),
      ),
    );
  }
}
