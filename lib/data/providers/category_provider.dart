import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/category_repository.dart';
import 'database_provider.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final database = ref.read(databaseProvider);

  return CategoryRepository(database);
});

final categoriesProvider = FutureProvider((ref) async {
  return ref.read(categoryRepositoryProvider).getAllCategories();
});
