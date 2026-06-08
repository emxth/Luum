import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/transaction_provider.dart';
import '../providers/category_list_provider.dart';
import '../providers/transaction_list_provider.dart';
import '../providers/payment_method_list_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String transactionType;
  final String? transactionId;

  const AddTransactionScreen({
    super.key,
    required this.transactionType,
    this.transactionId,
  });

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  String? selectedCategoryId;
  String? selectedPaymentMethodId;
  DateTime selectedDate = DateTime.now();

  // Saves the transaction to the database and updates the transaction list.
  Future<void> saveTransaction() async {
    if (selectedCategoryId == null) {
      return;
    }

    final repository = ref.read(transactionRepositoryProvider);

    final now = DateTime.now().toIso8601String();

    bool validate() {
      if (amountController.text.isEmpty) {
        return false;
      }

      if (selectedCategoryId == null) {
        return false;
      }

      return true;
    }

    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      return;
    }

    if (!validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );

      return;
    }

    await repository.createTransaction(
      TransactionsCompanion.insert(
        id: const Uuid().v4(),
        date: selectedDate.toIso8601String(),
        amount: amount,
        type: widget.transactionType,
        categoryId: selectedCategoryId!,
        paymentMethodId: Value(selectedPaymentMethodId),
        note: Value(noteController.text.isEmpty ? null : noteController.text),
        createdAt: now,
        updatedAt: now,
      ),
    );

    if (mounted) {
      ref.invalidate(transactionsProvider);
      Navigator.pop(context);
    }
  }

  // Opens a date picker dialog and updates the selected date.
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.transactionType == 'expense'
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    final paymentMethods = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transactionType == 'expense' ? 'Add Expense' : 'Add Income',
        ),
      ),
      body: categories.when(
        data: (items) {
          return Column(
            children: [
              // Amount input field
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),

              // Date picker
              ListTile(
                title: Text(selectedDate.toString().split(' ')[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: pickDate,
                ),
              ),

              // Category dropdown
              DropdownButton<String>(
                value: selectedCategoryId,
                hint: const Text('Category'),
                items: items.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
              ),

              // Payment method dropdown
              paymentMethods.when(
                data: (methods) {
                  return DropdownButton<String>(
                    value: selectedPaymentMethodId,
                    hint: const Text('Payment Method'),
                    items: methods.map((method) {
                      return DropdownMenuItem(
                        value: method.id,
                        child: Text(method.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethodId = value;
                      });
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              // Notes input field
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),

              // Save button
              ElevatedButton(
                onPressed: saveTransaction,
                child: const Text('Save'),
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text(e.toString()),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();

    super.dispose();
  }
}
