import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/category_provider.dart';

final expenseCategoriesProvider = FutureProvider((ref) async {
  final repository = ref.read(categoryRepositoryProvider);

  return repository.getExpenseCategories();
});

final incomeCategoriesProvider = FutureProvider((ref) async {
  final repository = ref.read(categoryRepositoryProvider);

  return repository.getIncomeCategories();
});
