import 'package:expense_app/domain/category.dart';

/// Persistence port for categories and subcategories (implemented in `data/`).
abstract class CategoryRepository {
  Stream<List<Category>> watchCategories();

  /// All subcategories (for resolving labels in expense lists).
  Stream<List<Subcategory>> watchAllSubcategories();

  Stream<List<Subcategory>> watchSubcategories(String categoryId);

  /// Creates a category and its system **Other** subcategory. Returns new category id.
  Future<String> createCategory({required String name, String? description});

  /// Creates a user subcategory under [categoryId]. Returns new subcategory id.
  Future<String> createSubcategory({
    required String categoryId,
    required String name,
    String? description,
  });

  Future<void> setCategoryName(String id, String name);

  Future<void> setSubcategoryName(String id, String name);

  /// Soft-deactivates a user subcategory. Throws [ReservedSubcategoryException]
  /// for the system **Other** row. Existing expenses keep their references.
  Future<void> deleteSubcategory(String id);

  /// Deactivates the category and all its subcategories.
  Future<void> deactivateCategory(String id);

  Future<void> reactivateCategory(String id);

  Future<void> reactivateSubcategory(String id);

  /// Persists optional user-facing notes (empty string clears to null).
  Future<void> setCategoryDescription(String id, String? description);

  Future<void> setSubcategoryDescription(String id, String? description);
}

class ReservedSubcategoryException implements Exception {
  ReservedSubcategoryException(this.message);
  final String message;

  @override
  String toString() => 'ReservedSubcategoryException: $message';
}
