import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'category_breakdown_provider.dart';

final topCategoryProvider = FutureProvider<String>((ref) async {
  final categories = await ref.read(categoryBreakdownProvider.future);

  if (categories.isEmpty) {
    return '-';
  }

  return categories.first.categoryName;
});
