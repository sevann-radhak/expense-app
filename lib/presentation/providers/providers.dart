import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/drift_category_repository.dart';
import 'package:expense_app/domain/domain.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('Override appDatabaseProvider in main() or tests.');
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DriftCategoryRepository(ref.watch(appDatabaseProvider));
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories();
});

final subcategoriesForCategoryProvider =
    StreamProvider.family<List<Subcategory>, String>((ref, categoryId) {
  return ref
      .watch(categoryRepositoryProvider)
      .watchSubcategories(categoryId);
});
