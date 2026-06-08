import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/transaction_provider.dart';
import '../providers/category_list_provider.dart';
import '../providers/transaction_list_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String transactionType;

  const AddTransactionScreen({super.key, required this.transactionType});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final amountController = TextEditingController();

  final noteController = TextEditingController();

  String? selectedCategoryId;

  Future<void> saveTransaction() async {
    if (selectedCategoryId == null) {
      return;
    }

    final repository = ref.read(transactionRepositoryProvider);

    final now = DateTime.now().toIso8601String();

    await repository.createTransaction(
      TransactionsCompanion.insert(
        id: const Uuid().v4(),
        date: now,
        amount: double.parse(amountController.text),
        type: widget.transactionType,
        categoryId: selectedCategoryId!,
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

  @override
  Widget build(BuildContext context) {
    final categories = widget.transactionType == 'expense'
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

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
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),

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

              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),

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
