import 'package:flutter/material.dart';

class CurrentMonthUsageCard extends StatelessWidget {
  final double income;
  final double expense;

  const CurrentMonthUsageCard({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(title: Text('Current Month')),

          ListTile(
            title: const Text('Income'),
            subtitle: Text('Rs. ${income.toStringAsFixed(2)}'),
          ),

          ListTile(
            title: const Text('Expense'),
            subtitle: Text('Rs. ${expense.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}
