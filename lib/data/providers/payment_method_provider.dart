import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/payment_method_repository.dart';
import 'database_provider.dart';

final paymentMethodRepositoryProvider = Provider<PaymentMethodRepository>((
  ref,
) {
  final database = ref.read(databaseProvider);

  return PaymentMethodRepository(database);
});
