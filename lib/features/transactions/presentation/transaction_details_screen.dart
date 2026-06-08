import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/transaction_details_provider.dart';

class TransactionDetailsScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(transactionDetailsProvider(transactionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: transaction.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Transaction not found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: ${item.amount}'),
              Text('Type: ${item.type}'),
              Text('Date: ${item.date}'),
              Text('Note: ${item.note ?? ''}'),
              
              ElevatedButton(
                onPressed: () {
                  context.push('/transactions/edit/${item.id}');
                },
                child: const Text('Edit'),
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text(e.toString()),
      ),
    );
  }
}
