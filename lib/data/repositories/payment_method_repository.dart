import '../database/app_database.dart';

class PaymentMethodRepository {
  final AppDatabase database;

  PaymentMethodRepository(this.database);

  Future<List<PaymentMethod>> getAllPaymentMethods() {
    return database.select(database.paymentMethods).get();
  }

  Future<void> createPaymentMethod(PaymentMethodsCompanion method) async {
    await database.into(database.paymentMethods).insert(method);
  }

  Future<void> updatePaymentMethod(PaymentMethod method) async {
    await database.update(database.paymentMethods).replace(method);
  }

  Future<void> deletePaymentMethod(String id) async {
    await (database.delete(
      database.paymentMethods,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> isPaymentMethodUsed(String paymentMethodId) async {
    final result = await (database.select(
      database.transactions,
    )..where((tbl) => tbl.paymentMethodId.equals(paymentMethodId))).get();

    return result.isNotEmpty;
  }

  Future<bool> deletePaymentMethodSafe(String id) async {
    final used = await isPaymentMethodUsed(id);

    if (used) {
      return false;
    }

    await deletePaymentMethod(id);

    return true;
  }

  Future<PaymentMethod?> getById(String id) {
    return (database.select(
      database.paymentMethods,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}
