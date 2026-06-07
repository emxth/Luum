import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/startup_provider.dart';
import '../../../features/transactions/providers/transaction_list_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(startupProvider);
    final transactions = ref.watch(transactionsProvider);

    return startup.when(
      loading: () {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (error, stackTrace) {
        return Scaffold(body: Center(child: Text(error.toString())));
      },
      data: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Luum')),
          body: transactions.when(
            data: (items) {
              return Text('Transactions: ${items.length}');
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text(e.toString()),
          ),
        );
      },
    );
  }
}
