import '../database/app_database.dart';

class SeedService {
  final AppDatabase database;

  SeedService(this.database);

  Future<void> seed() async {
    await _seedCategories();
    await _seedPaymentMethods();
  }

  Future<void> _seedCategories() async {
    final count = await database.categoryCount();

    if (count > 0) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    await database.batch((batch) {
      batch.insertAll(database.categories, [
        CategoriesCompanion.insert(
          id: 'cat_food',
          name: 'Food',
          type: 'expense',
          createdAt: now,
          updatedAt: now,
        ),
        CategoriesCompanion.insert(
          id: 'cat_transport',
          name: 'Transport',
          type: 'expense',
          createdAt: now,
          updatedAt: now,
        ),
        CategoriesCompanion.insert(
          id: 'cat_salary',
          name: 'Salary',
          type: 'income',
          createdAt: now,
          updatedAt: now,
        ),
        CategoriesCompanion.insert(
          id: 'cat_freelance',
          name: 'Freelance',
          type: 'income',
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    });
  }

  Future<void> _seedPaymentMethods() async {
    final count = await database.paymentMethodCount();

    if (count > 0) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    await database.batch((batch) {
      batch.insertAll(database.paymentMethods, [
        PaymentMethodsCompanion.insert(
          id: 'pm_cash',
          name: 'Cash',
          createdAt: now,
          updatedAt: now,
        ),
        PaymentMethodsCompanion.insert(
          id: 'pm_bank',
          name: 'Bank Account',
          createdAt: now,
          updatedAt: now,
        ),
        PaymentMethodsCompanion.insert(
          id: 'pm_credit',
          name: 'Credit Card',
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    });
  }
}
