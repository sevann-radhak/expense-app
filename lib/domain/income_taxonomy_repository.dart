import 'package:expense_app/domain/income_category.dart';

abstract class IncomeTaxonomyRepository {
  Stream<List<IncomeCategory>> watchIncomeCategories();

  Stream<List<IncomeSubcategory>> watchAllIncomeSubcategories();

  Stream<List<IncomeSubcategory>> watchIncomeSubcategories(String categoryId);

  Future<String> createIncomeCategory({required String name, String? description});

  Future<String> createIncomeSubcategory({
    required String categoryId,
    required String name,
    String? description,
  });

  Future<void> setIncomeCategoryName(String id, String name);

  Future<void> setIncomeSubcategoryName(String id, String name);

  /// Soft-deactivates a user income subcategory. Throws [ReservedSubcategoryException]
  /// for **Other**. Existing income rows keep their references.
  Future<void> deleteIncomeSubcategory(String id);

  Future<void> deactivateIncomeCategory(String id);

  Future<void> reactivateIncomeCategory(String id);

  Future<void> reactivateIncomeSubcategory(String id);

  Future<void> setIncomeCategoryDescription(String id, String? description);

  Future<void> setIncomeSubcategoryDescription(String id, String? description);
}
