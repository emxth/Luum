import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/payment_method_provider.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/settings/payment-methods/add');
        },
        child: const Icon(Icons.add),
      ),
      body: methods.when(
        data: (items) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final method = items[index];

              return ListTile(
                title: Text(method.name),
                trailing: method.isDefault
                    ? const Icon(Icons.lock)
                    : IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final repository = ref.read(
                            paymentMethodRepositoryProvider,
                          );

                          await repository.deletePaymentMethodSafe(method.id);

                          ref.invalidate(paymentMethodsProvider);
                        },
                      ),
                onTap: () {
                  context.push('/settings/payment-methods/edit/${method.id}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
