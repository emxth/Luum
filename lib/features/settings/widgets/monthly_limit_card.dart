import 'package:flutter/material.dart';

class MonthlyLimitCard extends StatelessWidget {
  final double monthlyLimit;

  const MonthlyLimitCard({super.key, required this.monthlyLimit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Monthly Limit'),
        subtitle: Text('Rs. ${monthlyLimit.toStringAsFixed(2)}'),
      ),
    );
  }
}
