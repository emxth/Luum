import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_bottom_navigation.dart';
import '../../../features/transactions/providers/transaction_list_provider.dart';
import '../../../data/providers/transaction_provider.dart';
import '../../settings/providers/budget_summary_provider.dart';
import '../../settings/providers/monthly_usage_provider.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: transactions.when(
        data: (items) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final transaction = items[index];

              return ListTile(
                title: Text('Rs. ${transaction.amount}'),
                subtitle: Text('${transaction.type} • ${transaction.date}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await ref
                        .read(transactionRepositoryProvider)
                        .deleteTransaction(transaction.id);

                    ref.invalidate(transactionsProvider);

                    ref.invalidate(budgetSummaryProvider);

                    ref.invalidate(monthlyUsageProvider);
                  },
                ),
                onTap: () {
                  context.push('/transactions/details/${transaction.id}');
                },
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text(e.toString()),
      ),

      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }
}
