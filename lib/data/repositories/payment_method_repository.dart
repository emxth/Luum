import '../database/app_database.dart';

class PaymentMethodRepository {
  final AppDatabase database;

  PaymentMethodRepository(this.database);

  Future<List<PaymentMethod>> getAll() {
    return database.select(database.paymentMethods).get();
  }
}
