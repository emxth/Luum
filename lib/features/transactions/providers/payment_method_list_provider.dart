import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/payment_method_provider.dart';

final paymentMethodsProvider = FutureProvider((ref) async {
  final repository = ref.read(paymentMethodRepositoryProvider);

  return repository.getAll();
});
