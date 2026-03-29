import 'package:expense_app/domain/income_category.dart';

abstract class IncomeTaxonomyRepository {
  Stream<List<IncomeCategory>> watchIncomeCategories();

  Stream<List<IncomeSubcategory>> watchAllIncomeSubcategories();

  Stream<List<IncomeSubcategory>> watchIncomeSubcategories(String categoryId);

  /// Deletes a user-defined income subcategory. Throws [ReservedSubcategoryException]
  /// for the system **Other** row.
  Future<void> deleteIncomeSubcategory(String id);

  Future<void> setIncomeCategoryDescription(String id, String? description);

  Future<void> setIncomeSubcategoryDescription(String id, String? description);
}
