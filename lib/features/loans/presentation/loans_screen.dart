import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/loans_provider.dart';
import '../../../data/providers/loan_provider.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      body: loans.when(
        data: (items) {
          return Column(
            children: [
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
