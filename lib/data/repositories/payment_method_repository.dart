import '../database/app_database.dart';

class PaymentMethodRepository {
  final AppDatabase database;

  PaymentMethodRepository(this.database);

  Future<List<PaymentMethod>> getAllPaymentMethods() {
    return database.select(database.paymentMethods).get();
  }
}
