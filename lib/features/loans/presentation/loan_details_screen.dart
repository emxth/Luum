import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loan_details_provider.dart';

class LoanDetailsScreen extends ConsumerWidget {
  final String loanId;

  const LoanDetailsScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loan = ref.watch(loanDetailsProvider(loanId));

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Details')),
      body: loan.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Not Found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.personName),

              Text('Amount: Rs. ${item.amount}'),

              Text('Type: ${item.loanType}'),

              Text('Status: ${item.status}'),

              Text('Loan Date: ${item.loanDate}'),

              Text('Due Date: ${item.dueDate ?? '-'}'),

              Text('Note: ${item.note ?? ''}'),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
