import '../database/app_database.dart';

class CategoryRepository {
  final AppDatabase database;

  CategoryRepository(this.database);

  Future<List<Category>> getAllCategories() {
    return database.select(database.categories).get();
  }

  Future<List<Category>> getExpenseCategories() {
    return (database.select(
      database.categories,
    )..where((tbl) => tbl.type.equals('expense'))).get();
  }

  Future<List<Category>> getIncomeCategories() {
    return (database.select(
      database.categories,
    )..where((tbl) => tbl.type.equals('income'))).get();
  }

  Future<void> createCategory(CategoriesCompanion category) async {
    await database.into(database.categories).insert(category);
  }

  Future<void> updateCategory(Category category) async {
    await database.update(database.categories).replace(category);
  }

  Future<void> deleteCategory(String id) async {
    await (database.delete(
      database.categories,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> isCategoryUsed(String categoryId) async {
    final result = await (database.select(
      database.transactions,
    )..where((tbl) => tbl.categoryId.equals(categoryId))).get();

    return result.isNotEmpty;
  }

  Future<bool> deleteCategorySafe(String id) async {
    final used = await isCategoryUsed(id);

    if (used) {
      return false;
    }

    await deleteCategory(id);

    return true;
  }

  Future<Category?> getById(String id) {
    return (database.select(
      database.categories,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}
