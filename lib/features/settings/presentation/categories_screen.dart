import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/category_provider.dart';
import '../../transactions/providers/category_list_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/settings/categories/add');
        },
        child: const Icon(Icons.add),
      ),
      body: categories.when(
        data: (items) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final category = items[index];

              return ListTile(
                title: Text(category.name),
                subtitle: Text(category.type),
                trailing: category.isDefault
                    ? const Icon(Icons.lock)
                    : IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final repository = ref.read(
                            categoryRepositoryProvider,
                          );

                          final success = await repository.deleteCategorySafe(
                            category.id,
                          );

                          if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cannot delete category'),
                              ),
                            );
                          }

                          ref.invalidate(categoriesProvider);
                          ref.invalidate(expenseCategoriesProvider);
                          ref.invalidate(incomeCategoriesProvider);
                        },
                      ),
                onTap: () {
                  context.push('/settings/categories/edit/${category.id}');
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
