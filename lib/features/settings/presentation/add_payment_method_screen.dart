import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/payment_method_provider.dart';

class AddPaymentMethodScreen extends ConsumerStatefulWidget {
  final String? paymentMethodId;

  const AddPaymentMethodScreen({super.key, this.paymentMethodId});

  @override
  ConsumerState<AddPaymentMethodScreen> createState() =>
      _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState
    extends ConsumerState<AddPaymentMethodScreen> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.paymentMethodId != null) {
      _loadMethod();
    }
  }

  Future<void> _loadMethod() async {
    final repository = ref.read(paymentMethodRepositoryProvider);

    final method = await repository.getById(widget.paymentMethodId!);

    if (method != null) {
      nameController.text = method.name;
    }
  }

  Future<void> saveMethod() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }

    final repository = ref.read(paymentMethodRepositoryProvider);

    final now = DateTime.now().toIso8601String();

    if (widget.paymentMethodId == null) {
      await repository.createPaymentMethod(
        PaymentMethodsCompanion.insert(
          id: const Uuid().v4(),
          name: nameController.text.trim(),
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      final existing = await repository.getById(widget.paymentMethodId!);

      if (existing != null) {
        await repository.updatePaymentMethod(
          existing.copyWith(name: nameController.text.trim(), updatedAt: now),
        );
      }
    }

    ref.invalidate(paymentMethodsProvider);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.paymentMethodId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit Payment Method' : 'Add Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: saveMethod,
              child: Text(editing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
