import 'package:expense_app/domain/category.dart';

/// Persistence port for categories and subcategories (implemented in `data/`).
abstract class CategoryRepository {
  Stream<List<Category>> watchCategories();

  Stream<List<Subcategory>> watchSubcategories(String categoryId);

  /// Deletes a user-defined subcategory. Throws [ReservedSubcategoryException]
  /// for the system **Other** row.
  Future<void> deleteSubcategory(String id);
}

class ReservedSubcategoryException implements Exception {
  ReservedSubcategoryException(this.message);
  final String message;

  @override
  String toString() => 'ReservedSubcategoryException: $message';
}
