import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/goal_provider.dart';

final goalContributionsProvider = FutureProvider.family((
  ref,
  String goalId,
) async {
  final repository = ref.read(goalRepositoryProvider);

  return repository.getContributions(goalId);
});
