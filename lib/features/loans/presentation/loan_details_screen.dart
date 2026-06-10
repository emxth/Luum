import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/loan_payments_provider.dart';
import '../providers/loan_summary_provider.dart';

class LoanDetailsScreen extends ConsumerWidget {
  final String loanId;

  const LoanDetailsScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(loanSummaryProvider(loanId));
    final payments = ref.watch(loanPaymentsProvider(loanId));

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Details')),
      body: summary.when(
        data: (summaryData) {
          if (summaryData == null) {
            return const Center(child: Text('Not Found'));
          }

          final loan = summaryData.loan;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loan.personName),

              Text('Amount: Rs. ${loan.amount}'),

              Text('Type: ${loan.loanType}'),

              Text('Paid: Rs. ${summaryData.paid}'),

              Text('Remaining: Rs. ${summaryData.remaining}'),

              LinearProgressIndicator(value: summaryData.progress),

              Text('${(summaryData.progress * 100).toStringAsFixed(1)}%'),

              Text('Loan Date: ${loan.loanDate}'),

              Text('Due Date: ${loan.dueDate ?? '-'}'),

              Text('Note: ${loan.note ?? ''}'),

              Text('Status: ${loan.status}'),

              ElevatedButton(
                onPressed: () {
                  context.push('/loans/$loanId/payment');
                },
                child: const Text('Add Payment'),
              ),

              const Divider(),

              const Text('Payment History'),

              Expanded(
                child: payments.when(
                  data: (items) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final payment = items[index];

                        return ListTile(
                          title: Text('Rs. ${payment.amount}'),
                          subtitle: Text(payment.paymentDate),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text(e.toString()),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
