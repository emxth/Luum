import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/loan_dashboard_provider.dart';
import '../providers/loans_provider.dart';
import '../../../data/providers/loan_provider.dart';
import '../providers/pending_payables_provider.dart';
import '../providers/pending_receivables_provider.dart';
import '../providers/recent_loan_activity_provider.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      body: loans.when(
        data: (items) {
          final dashboard = ref.watch(loanDashboardProvider);
          final recent = ref.watch(recentLoanActivityProvider);

          return Column(
            children: [
              dashboard.when(
                data: (data) {
                  return Column(
                    children: [
                      Text('Receivable: Rs. ${data.totalReceivable}'),

                      Text('Payable: Rs. ${data.totalPayable}'),

                      Text('Pending: ${data.pendingLoans}'),

                      Text('Completed: ${data.completedLoans}'),

                      const Divider(),

                      const Text('Recent Activity'),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              recent.when(
                data: (items) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return ListTile(
                        title: Text('Rs. ${item.amount}'),
                        subtitle: Text(item.paymentDate),
                      );
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              ElevatedButton(
                onPressed: () {
                  context.push('/loans/add');
                },
                child: const Text('Add Loan'),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final loan = items[index];

                    return ListTile(
                      title: Text(loan.personName),
                      subtitle: Text('${loan.loanType} • Rs. ${loan.amount}'),

                      leading: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push('/loans/edit/${loan.id}');
                        },
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await ref
                              .read(loanRepositoryProvider)
                              .deleteLoan(loan.id);

                          ref.invalidate(loansProvider);

                          ref.invalidate(loanDashboardProvider);

                          ref.invalidate(pendingReceivablesProvider);

                          ref.invalidate(pendingPayablesProvider);

                          ref.invalidate(recentLoanActivityProvider);
                        },
                      ),

                      onTap: () {
                        context.push('/loans/details/${loan.id}');
                      },
                    );
                  },
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
