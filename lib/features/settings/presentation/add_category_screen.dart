import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/category_provider.dart';
import '../../transactions/providers/category_list_provider.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  final String? categoryId;

  const AddCategoryScreen({
    super.key,
    this.categoryId,
  });

  @override
  ConsumerState<AddCategoryScreen> createState() =>
      _AddCategoryScreenState();
}

class _AddCategoryScreenState
    extends ConsumerState<AddCategoryScreen> {
  final nameController = TextEditingController();

  String selectedType = 'expense';

  @override
  void initState() {
    super.initState();

    if (widget.categoryId != null) {
      _loadCategory();
    }
  }

  Future<void> _loadCategory() async {
    final repository =
        ref.read(categoryRepositoryProvider);

    final category =
        await repository.getById(widget.categoryId!);

    if (category != null) {
      nameController.text = category.name;

      setState(() {
        selectedType = category.type;
      });
    }
  }

  Future<void> saveCategory() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }

    final repository =
        ref.read(categoryRepositoryProvider);

    final now = DateTime.now().toIso8601String();

    if (widget.categoryId == null) {
      await repository.createCategory(
        CategoriesCompanion.insert(
          id: const Uuid().v4(),
          name: nameController.text.trim(),
          type: selectedType,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      final existing =
          await repository.getById(widget.categoryId!);

      if (existing != null) {
        await repository.updateCategory(
          existing.copyWith(
            name: nameController.text.trim(),
            type: selectedType,
            updatedAt: now,
          ),
        );
      }
    }

    ref.invalidate(categoriesProvider);
    ref.invalidate(expenseCategoriesProvider);
    ref.invalidate(incomeCategoriesProvider);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.categoryId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'Edit Category' : 'Add Category',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: 'Name'),
            ),

            const SizedBox(height: 16),

            DropdownButton<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(
                  value: 'expense',
                  child: Text('Expense'),
                ),
                DropdownMenuItem(
                  value: 'income',
                  child: Text('Income'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: saveCategory,
              child: Text(
                editing ? 'Update' : 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }
}