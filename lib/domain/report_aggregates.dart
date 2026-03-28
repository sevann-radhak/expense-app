import 'package:expense_app/domain/expense.dart';

/// Sum of [Expense.amountUsd] (already FX-converted at save time).
double totalUsd(Iterable<Expense> expenses) {
  var s = 0.0;
  for (final e in expenses) {
    s += e.amountUsd;
  }
  return s;
}

/// Share of [part] in [whole] as a percentage in `[0, 100]`.
double percentOfTotal(double part, double whole) {
  if (whole <= 0) {
    return 0;
  }
  return (part / whole) * 100;
}

/// One row per category, sorted by [totalUsd] descending.
List<CategoryUsdAggregate> aggregateUsdByCategory(Iterable<Expense> expenses) {
  final map = <String, double>{};
  for (final e in expenses) {
    map[e.categoryId] = (map[e.categoryId] ?? 0) + e.amountUsd;
  }
  final list =
      map.entries
          .map(
            (e) => CategoryUsdAggregate(categoryId: e.key, totalUsd: e.value),
          )
          .toList()
        ..sort((a, b) => b.totalUsd.compareTo(a.totalUsd));
  return list;
}

/// Subcategories under [categoryId], sorted by [totalUsd] descending.
List<SubcategoryUsdAggregate> aggregateUsdBySubcategoryForCategory(
  Iterable<Expense> expenses,
  String categoryId,
) {
  final map = <String, double>{};
  for (final e in expenses) {
    if (e.categoryId == categoryId) {
      map[e.subcategoryId] = (map[e.subcategoryId] ?? 0) + e.amountUsd;
    }
  }
  final list =
      map.entries
          .map(
            (e) => SubcategoryUsdAggregate(
              subcategoryId: e.key,
              totalUsd: e.value,
            ),
          )
          .toList()
        ..sort((a, b) => b.totalUsd.compareTo(a.totalUsd));
  return list;
}

final class CategoryUsdAggregate {
  const CategoryUsdAggregate({
    required this.categoryId,
    required this.totalUsd,
  });

  final String categoryId;
  final double totalUsd;
}

final class SubcategoryUsdAggregate {
  const SubcategoryUsdAggregate({
    required this.subcategoryId,
    required this.totalUsd,
  });

  final String subcategoryId;
  final double totalUsd;
}
