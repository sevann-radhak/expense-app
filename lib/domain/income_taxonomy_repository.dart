import 'package:expense_app/domain/income_category.dart';

abstract class IncomeTaxonomyRepository {
  Stream<List<IncomeCategory>> watchIncomeCategories();

  Stream<List<IncomeSubcategory>> watchAllIncomeSubcategories();

  Stream<List<IncomeSubcategory>> watchIncomeSubcategories(String categoryId);
}
